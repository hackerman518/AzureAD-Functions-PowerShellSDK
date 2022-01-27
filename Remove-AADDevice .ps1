function Remove-AADDevice {

	<#
		IMPORTANT:
        ===========================================================================
        This script is provided 'as is' without any warranty. Any issues stemming 
        from use is on the user.
        ===========================================================================
		.DESCRIPTION
		This function will remove an Azure AD Device.
		===========================================================================
		.PARAMETER ID
		This parameter is required and specifies the target device by object ID
		===========================================================================
		.EXAMPLE
		Remove-AzureADDevice -ID {object ID} <--- This will remove an Azure AD Device based on object ID
	#>

	[CmdletBinding()]
    param(
	[parameter()]
	[String]$ID,
	[parameter()]
	[String]$Name
    )

	#Ensuring the needed modules are installed
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Identity.DirectoryManagement")) {

        Install-Module -Name "Microsoft.Graph.Identity.DirectoryManagement" -Repository PSGallery -Force -AllowClobber

    }


	If ($ID -ne $Null -and $ID -ne ""){

		Try {

			#Obtaining device based on ID
			$Target = Get-MgDevice -All | where {$_.Id -eq $ID}
			Remove-MgDevice -deviceId $Target.Id

		}
		Catch {

			$e = $_Exception
			$Line = $_.InvocationInfo.ScriptLineNumber
			Write-Host "An error occurred at line $($Line):" -f Red
			Write-Host "$_" -f Red

		}

	}
	elseif ($Name -ne $null -and $Name -ne ""){

		Try {

			#Obtaining device based on displayName/PC Name
			$Target = Get-MgDevice -All | where {$_.displayName -eq $DisplayName}
			Remove-MgDevice -deviceId $Target.Id

		}
		Catch {

			$e = $_Exception
			$Line = $_.InvocationInfo.ScriptLineNumber
			Write-Host "An error occurred at line $($Line):" -f Red
			Write-Host "$_" -f Red

		}

		}

}