function Get-AADDevice {

	<#
		IMPORTANT:
        ===========================================================================
        This script is provided 'as is' without any warranty. Any issues stemming 
        from use is on the user.
        ===========================================================================
		.DESCRIPTION
		Gets an Azure AD device
		===========================================================================
		.PARAMETER Name
		This parameter is used to target a device by name.
		.PARAMETER Id
		This parameter is used to target a device by Id.
		===========================================================================
		.EXAMPLE
		Get-AzureADDevice <--- This will return all AzureAD devices
		Get-AzureADDevice -Name Desktop-SJ87X <--- This will return the named device
		Get-AzureADDevice -Id {object id} <--- This will return the device based on object id
	#>

    [CmdletBinding()]
    param(
    [Parameter()]
    [String]$Name,
	[parameter()]
	[String]$ID
    )

	#Ensuring the needed modules are installed
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Identity.DirectoryManagement")) {

        Install-Module -Name "Microsoft.Graph.Identity.DirectoryManagement" -Repository PSGallery -Force -AllowClobber

    }

    If (($Name -eq $Null -or $Name -eq "") -and ($ID -eq $null -or $ID -eq "")) {

        try {

			#Listing all AADDevices if neither name nor ID is specified
			Write-Host "Getting all users..." -f Yellow
			Get-MgDevice -All

    	}
        catch{

			$e = $_Exception
			$Line = $_.InvocationInfo.ScriptLineNumber
        	Write-Host "An error occurred at line $($Line):" -f Red
        	Write-Host "$_" -f Red

    	}

    }
    elseif ($ID -ne $Null -and $ID -ne "") {

        try {

			#Listing AADDevice based on Id
			Write-host "Looking up target..." -f Yellow
	        Get-MgDevice -All | where {$_.Id -eq $Id}

    	}
    	catch{

        	$e = $_Exception
			$Line = $_.InvocationInfo.ScriptLineNumber
        	Write-Host "An error occurred at line $($Line):" -f Red
        	Write-Host "$_" -f Red

	    }

    }
	elseif ($Name -ne $Null -and $Name -ne ""){

		try {

			#Listing AADDevice based on displayName
			Write-Host "Lookingu p target..." -f Yellow
        	Get-MgDevice -All | where {$_.displayName -eq $Name}

		}
		catch{

			$e = $_Exception
			$Line = $_.InvocationInfo.ScriptLineNumber
        	Write-Host "An error occurred at line $($Line):" -f Red
        	Write-Host "$_" -f Red

		}

	}

}