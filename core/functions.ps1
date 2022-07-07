FUNCTION TOOL_SELECT {
    Write-Host -ForegroundColor "Cyan" ("
        - - - - - - - - - - - - - - -`n
        $($global:config.appInfo.info | Out-String)
        CREATED BY:     $($global:config.appInfo.creator | Out-String)
        UPDATED:        $($global:config.appInfo.date | Out-String)
        VERSION:        $($global:config.appInfo.appver | Out-String)
        - - - - - - - - - - - - - - -
    ")

    Write-Host -ForegroundColor "Cyan" ("
        - - - - - - - - - - - - - - - - - - - - - - - 
        |                                           |
        |   SELECT WHAT MODULE YOU WISH TO USE:     |
        |   - - - - - - - - - - - - - - - - - -     |
        |                                           |
        |   1: EXCHANGE MODULE                      |
        |   2: AZURE AD MODULE                      |
        |                                           |
        - - - - - - - - - - - - - - - - - - - - - - -
    ")

    FUNCTION GET_MODULE {
        $moduleSelection = Read-Host -Prompt ("INPUT MODULE SELECTION (1-2)")
        switch ($moduleSelection) {
            1 {
                Write-Host -ForegroundColor "Green" ("`nSELECTED EXCHANGE MODULE - CHECKING TO`nENSURE MODULE HAS BEEN INSTALLED...")
                CHECK_MODULE("EXCHANGE")
            }
            2 {
                Write-Host -ForegroundColor "Green" ("`nSELECTED AZURE AD MODULE - CHECKING TO`nENSURE MODULE HAS BEEN INSTALLED...")
                CHECK_MODULE("AZUREAD")
            }
            default {
                Write-Host -ForegroundColor "Red" ("`nUNDEFINED INPUT - RETURNING...")
                GET_MODULE
            }
        }      
    }
    #CALL ABOVE FUNCTION
    GET_MODULE
}

FUNCTION CHECK_MODULE ($module) {
    switch ($module) {
        "EXCHANGE" {
            $exchangeModule = Get-Module ExchangeOnlineManagement -ListAvailable
            if ($exchangeModule.count -eq 0) {
                Write-Host -ForegroundColor "Red" ("`nERROR: EXCHANGE MODULE MISSING!`n[Y] TO INSTALL`n[N] TO RETURN")
                $moduleInstall = Read-Host -Prompt ("INPUT SELECTION")
                if ($moduleInstall -match "[yY]") { 
                    Write-Host -ForegroundColor "Green" ("`nNOW ATTEMPTING TO INSTALL THE EXCHANGE MODULE...")
                    Install-Module ExchangeOnlineManagement -Repository PSGallery -AllowClobber -Force
                } else {
                    Write-Host -ForegroundColor "Red" ("`nEXCHANGE MODULE IS REQUIRED TO USE THIS SECTION OF THE TOOL!") 
                    TOOL_SELECT
                }
            }
            Write-host -ForegroundColor "Green" ("`nEXCHANGE MODULE DETECTED - ATTEMPTING CONNECTION TO EXCHANGE...`n")
            try {Connect-ExchangeOnline -ShowBanner:$false} catch {
                Write-Host -ForegroundColor "Red" ("`nERROR DETECTED WHEN CONNECTING TO EXCHANGE - RETURNING...`n")
                TOOL_SELECT
            }
            EXCHANGE_ACTIONS
        }
        "AZUREAD" {
            $azureModule = Get-Module AzureAD -ListAvailable
            if ($azureModule.count -eq 0) {
                Write-Host -ForegroundColor "Red" ("`nERROR: AZURE AD MODULE MISSING!`n[Y] TO INSTALL`n[N] TO RETURN")
                $moduleInstall = Read-Host -Prompt ("INPUT SELECTION")
                if ($moduleInstall -match "[yY]") { 
                    Write-Host -ForegroundColor "Green" ("`nNOW ATTEMPTING TO INSTALL THE AZURE AD MODULE...")
                    Install-Module AzureAD -Repository PSGallery -AllowClobber -Force
                } else {
                    Write-Host -ForegroundColor "Red" ("`nAZURE AD MODULE IS REQUIRED TO USE THIS SECTION OF THE TOOL!") 
                    TOOL_SELECT
                }
            }
            Write-host -ForegroundColor "Green" ("`nAZURE AD MODULE DETECTED - ATTEMPTING CONNECTION TO AZURE...`n")
            try {Connect-AzureAD} catch {
                Write-Host -ForegroundColor "Red" ("`nERROR DETECTED WHEN CONNECTING TO AZURE AD - RETURNING...`n")
                TOOL_SELECT
            }
        }
        default {
            Write-Host -ForegroundColor "Red" ("`nHIT ERROR - RETURNING...`n")
            TOOL_SELECT
        }
    }
}

FUNCTION EXCHANGE_ACTIONS {
    Write-Host -ForegroundColor "Cyan" ("
        - - - - - - - - - - - - - - - - - - - - - - - 
        |                                           |
        |    SELECT WHAT TOOL YOU WISH TO USE:      |
        |    - - - - - - - - - - - - - - - - -      |
        |                                           |
        |   1: MANAGE MAILBOX PERMISSIONS           |
        |   2: MANAGE MAILBOX SETTINGS              |
        |                                           |
        - - - - - - - - - - - - - - - - - - - - - - -
    ")
    $toolSelection = Read-Host -Prompt ("INPUT MODULE SELECTION (1-2)")
    switch ($toolSelection) {
        1 {
            Write-Host -ForegroundColor "Cyan" ("`nSELECTED MAILBOX PERMISSIONS TOOL`nLOADING FUNCTION...")
            MAILBOX_TOOL("PERMISSIONS")
        }
        2 {
            Write-Host -ForegroundColor "Cyan" ("`nSELECTED MAILBOX SETTINGS TOOL`nLOADING FUNCTION...")
            MAILBOX_TOOL("SETTINGS")
        }
        default {
            Write-Host -ForegroundColor "Red" ("`nUNDEFINED INPUT - RETURNING...")
            EXCHANGE_ACTIONS
        }
    }
}

FUNCTION MAILBOX_TOOL ($action) {
    switch ($action) {
        "PERMISSIONS" {
            Write-Host -ForegroundColor "Cyan" ("`nCLEARING CONSOLE...")
            Clear-Host
            Write-Host -ForegroundColor "Cyan" ("
                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                |                                                                                   |
                |                           SELECT PERMISSION TYPE:                                 |
                |                           - - - - - - - - - - - -                                 |
                |                                                                                   |
                |   1: MANAGE DIRECT MAILBOX PERMS      |       4: REMOVE AUTO MAPPING              |
                |   2: MANAGE BULK MAILBOX PERMS        |       5: REMOVE AUTO MAPPING BULK         |
                |   3: MANAGE CALENDAR / FOLDER PERMS   |       6: RUN MAILBOX PERMISSION REPORT    |
                |                                                                                   |               
                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            ")
            $permissionSelection = Read-Host -Prompt ("INPUT MODULE SELECTION (1-6)")
            $objectEmail = Read-Host -Prompt ("ENTER EMAIL ADDRESS OF THE OBJECT BEING CHANGED")
            #CHECK_EMAIL($objectEmail)
            switch ($permissionSelection) {
                1 {
                    $userEmail = Read-Host -Prompt ("ENTER EMAIL ADDRESS OF THE USER GETTING PERMS")
                    #CHECK_EMAIL($userEmail, $returnEmail)
                    GET_ACCESS_RIGHTS
                    GET_AUTO_MAPPING
                    Clear-Host
                    Write-Host -ForegroundColor "Cyan" ("
                        CONFIRM THE ACTION:

                        OBJECT EMAIL:       $($global:config.mailboxPermsInfo.objectEmail | Out-String)
                        USER EMAIL:         $($global:config.mailboxPermsInfo.userEmail | Out-String)
                        ACCESS RIGHTS:      $($global:config.mailboxPermsInfo.accessRights | Out-String)
                        AUTO MAPPING:       $($global:config.mailboxPermsInfo.autoMapping | Out-String)

                        [Y] TO RUN
                        [N] TO CHANGE
                    ")
                    $runConfirm = Read-Host -Prompt ("INPUT ACTION")
                    if ($runConfirm -match "[yY]") { 
                       # Write-Host ("Add-MailboxPermission -Identity "$objectEmail" -User "$getUserEmail" -AccessRights "$accessRight" -AutoMapping $autoMapping)
                    } else {
                        # ADD SOME ACTION HERE
                    }
                }
            }
        }
        2 {
            Write-Host -ForegroundColor "Cyan" ("`nSELECTED MAILBOX SETTINGS TOOL`nLOADING FUNCTION...")
            MAILBOX_TOOL("SETTINGS")
        }
        default {
            Write-Host -ForegroundColor "Red" ("`nUNDEFINED INPUT - RETURNING...")
            EXCHANGE_ACTIONS
        }
    }    
}