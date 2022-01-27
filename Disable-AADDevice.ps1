function Disable-AADDevice {

	<#
		IMPORTANT:
        ===========================================================================
        This script is provided 'as is' without any warranty. Any issues stemming 
        from use is on the user.
        ===========================================================================
		.DESCRIPTION
		This function will disable an Azure AD Device.
		===========================================================================
		.PARAMETER ID
		This parameter is required and specifies the target device by object ID
		===========================================================================
		.EXAMPLE
		Disable-AzureADDevice -ID {object ID} <--- This will disable an Azure AD Device based on object ID
		Disable-AzureADDevice -ID DESKTOP-H8JX95 <--- This will disable the Azure AD Device based on PC name
	#>

	[CmdletBinding()]
    param(
	[parameter()]
	[String]$ID,
	[Parameter()]
	[String]$Name
    )

	#Ensuring the needed modules are installed
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Identity.DirectoryManagement")) {

        Install-Module -Name "Microsoft.Graph.Identity.DirectoryManagement" -Repository PSGallery -Force -AllowClobber

    }


	If ($ID -ne $Null -and $ID -ne ""){

		Try {

		#Getting device based on Id
		Write-Host "Looking up target..." -f Yellow
		$Target = Get-MgDevice -All | where {$_.Id -eq $ID}
		Write-Host "Disabling $($Target.displayName)"
		Update-MgDevice -deviceId $Target.Id -AccountEnabled:$False

		}
		Catch {

			$e = $_Exception
			$Line = $_.InvocationInfo.ScriptLineNumber
			Write-Host "An error occurred at line $($Line):" -f Red
			Write-Host "$_" -f Red

		}

	}
	elseif ($Name -ne $Null -and $Name -ne ""){

		Try {

		#Getting device based on displayName
		Write-Host "Looking up target..." -f Yellow
		$Target = Get-MgDevice -All | where {$_.displayName -eq $Name}
		Write-Host "Disabling $($Target.displayName)"
		Update-MgDevice -deviceId $Target.Id -AccountEnabled:$False
		
		}
		Catch {

			$e = $_Exception
			$Line = $_.InvocationInfo.ScriptLineNumber
			Write-Host "An error occurred at line $($Line):" -f Red
			Write-Host "$_" -f Red

		}

	}

}