<#
FUNCTION CHECK_EMAIL ($emailData) {
    Write-Host -ForegroundColor "Red" ("`nCONFIRM THE EMAIL ADDRESS: $emailData.`n[Y] TO CONFIRM`n[N] TO CHANGE")
    $emailConfirm = Read-Host -Prompt ("INPUT SELECTION")
    if ($emailConfirm -match "[yY]") {
        return $returnEmail = $emailData
    else {
        CHECK_EMAIL
    }
}
#>

FUNCTION GET_ACCESS_RIGHTS {
    Write-Host -ForegroundColor "Cyan" ("
        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        |                                                         |
        |                SELECT ACCESS RIGHTS:                    |
        |                - - - - - - - - - - -                    |
        |                                                         |
        |   1: ChangeOwner          |       4: ExternalAccount    |
        |   2: ChangePermission     |       5: FullAccess         |
        |   3: DeleteItem           |       6: ReadPermission     |
        |                                                         |               
        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ")
    $accessRights = Read-Host -Prompt ("INPUT ACCESS RIGHTS SELECTION (1-6)")
    switch ($accessRights) {
        1 {
            $global:config.mailboxPermsInfo.accessRights = "ChangeOwner"
        }
        2 {
            $global:config.mailboxPermsInfo.accessRights = "ChangePermission"
        }
        3 {
            $global:config.mailboxPermsInfo.accessRights = "DeleteItem"
        }
        4 {
            $global:config.mailboxPermsInfo.accessRights = "ExternalAccount"
        }
        5 {
            $global:config.mailboxPermsInfo.accessRights = "FullAccess"
        }
        6 {
            $global:config.mailboxPermsInfo.accessRights = "ReadPermission"
        }
        default {
            Write-Host -ForegroundColor "Red" ("`nUNDEFINED INPUT - RETURNING...")
            GET_ACCESS_RIGHTS       
        }        
    }
}

FUNCTION GET_AUTO_MAPPING {
    Write-Host -ForegroundColor "Cyan" ("ENABLE AUTO MAPPING:`n[Y] TO ENABLE`n[N] TO DISABLE")
    $autoMapping = Read-Host -Prompt ("INPUT SELECTION")
    if ($autoMapping -match "[yY]") { 
        $global:config.mailboxPermsInfo.autoMapping = "false"
    } else {
        $global:config.mailboxPermsInfo.autoMapping = "true"
    }
}