function Set-AADUserManager {

    <#
        IMPORTANT:
        ===========================================================================
        This script is provided 'as is' without any warranty. Any issues stemming 
        from use is on the user.
        ===========================================================================
		.DESCRIPTION
		Updates AzureAD Manager
        
        ===========================================================================
		.PARAMETER User
		This parameter is used to target a user by email
		.PARAMETER NewManager
		This parameter is used to specify the new manager
        ===========================================================================
		.EXAMPLE
		Set-AzureADUserManager -User bob@contoso.com -NewManager jim@contoso.com <--- This will update Bob's manager to Jim
	#>

    [cmdletbinding()]
    param(
    [Parameter(Mandatory = $true)]
    [String]$User,
    [cmdletbinding()]
    [Parameter(Mandatory = $True)]
    [String]$NewManager
    )

    #Ensuring the needed modules are installed
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Users")) {

        Install-Module -Name "Microsoft.Graph.Users" -Repository PSGallery -Force -AllowClobber

    }

    $User = Get-MgUser -UserId $User
    $Mgr = Get-MgUser -UserId $NewManager | select -expand Id
    $MgrUpdate = @{

        "@odata.id" = "https://grpah.microsoft.com/v1.0/users/$Mgr"

    }
    Try {

        Set-MgUserManagerByRef -UserId $User.Id -BodyParameter $MgrUpdate
    }
    Catch {

        $e = $_Exception
        $Line = $_.InvocationInfo.ScriptLineNumber
        Write-Host "An error occurred at line $($Line):" -f Red
        Write-Host "$_" -f Red

    }

}