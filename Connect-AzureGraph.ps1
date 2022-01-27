function Connect-AzureGraph {

    [cmdletbinding()]
    param(
    [Parameter()]
    [String]$AppID,
    [Parameter()]
    [String]$TenantID,
    [Parameter()]
    [Switch]$Cert,
    [Parameter()]
    [Switch]$ClientSecret,
    [Parameter()]
    [String]$Thumbprint,
    [Parameter()]
    [String]$Secret
    )

    <#
		IMPORTANT:
        ===========================================================================
        This script is provided 'as is' without any warranty. Any issues stemming 
        from use is on the user.
        ===========================================================================
		.DESCRIPTION
		Authenticates with MS Graph
		===========================================================================
		.PARAMETER AppID
		AppID of the registered Azure application (if using one)
		.PARAMETER TenantID
		Id of your Azure tenant, found here: https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties
        .PARAMETER Cert
        Switch to use certificate-based authentication
        .PARAMETER ClientSecret
        Switch to use Client/Secret-based authentication
        .PARAMETER SECRET
        Your client secret
	#>

    #Ensuring the needed modules are installed
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Authentication")) {

	Install-Module -Name "Microsoft.Graph.Authentication" -Repository PSGallery -Force -AllowClobber

    }
    if (-Not(Get-Module -ListAvailable -Name "MSAL.PS")) {

	Install-Module -Name "MSAL.PS" -Repository PSGallery -Force -AllowClobber

    }

    If ($Cert) {

        Write-Host "Connecting to MS Graph. . ." -f Yellow
        Connect-MgGraph -ClientID $AppID -TenantID $TenantID -CertificateThumbprint $Thumbprint

    }
    elseif ($ClientSecret) {

        Write-Host "Connecting to MS Graph. . ." -f Yellow
        $MsalToken = Get-MsalToken -TenantId $TenantId -ClientId $AppId -ClientSecret ($ClientSecret | ConvertTo-SecureString -AsPlainText -Force)
        Connect-Graph -AccessToken $MsalToken.AccessToken

    }
    else {

        Connect-MgGraph

    }

}
