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
                Write-Host -ForegroundColor "Red" ("`nERROR: EXCHANGE MODULE MISSING!`n[Y] TO INSTALL`n[N] TO RETURN`n")
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
                Write-Host -ForegroundColor "Red" ("`nERROR: AZURE AD MODULE MISSING!`n[Y] TO INSTALL`n[N] TO RETURN`n")
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
    $toolSelection = Read-Host -Prompt ("INPUT SELECTION")
}
