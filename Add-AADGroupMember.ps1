function Add-AADGroupMember {

    <#
        IMPORTANT:
        ===========================================================================
        This script is provided 'as is' without any warranty. Any issues stemming 
        from use is on the user.
        ===========================================================================
		.DESCRIPTION
		Adds user to AzureAD Group
        ===========================================================================
		.PARAMETER Group
		DisplayName of the group (how you see it in the GUI)
		.PARAMETER User
		User's email
        .PARAMETER Multi
        Use this switch if you have multiple groups to add a user to. Must be used in conjunction with File parameter
        .PARAMETER File
        Specifies the text file where you store each of the groups you want to add users to
        ===========================================================================
		.EXAMPLE
		Add-AADGroupMember -Group "Intune 7-Zip" -User bob@Contoso.com <--- This will add Bob to the Intune 7-Zip group
        Add-AADGroupMember -User bob@contoso.com -Multi -File "C:\Temp\Groups.txt" This will parse the txt file and add user to all groups in it, if they exist
	#>

    [cmdletbinding()]
    param(
    [Parameter()]
    [String]$Group,
    [Parameter()]
    [String]$User,
    [Parameter()]
    [Switch]$Multi,
    [Parameter()]
    [String]$File
    )

    #Ensuring the needed modules are installed
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Groups")) {

        Install-Module -Name "Microsoft.Graph.Groups" -Repository PSGallery -Force -AllowClobber

    }
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Users") {

        Install-Module -Name "Microsoft.Graph.Users" -Repository -PSGallery -Force -AllowClobber

    }

    #Obtain UserId
    $UserId = Get-MgUser -UserId $User | select -expand Id
    
    If ($Multi) {

        #Ensuring a file is specificed when Multi switch is used
        If ($File -ne $Null -and $File -ne ""){
    
            #Parsing the file
            $Fetch = Get-content $File
            #Looping through the groups
            foreach ($Line in $Fetch) {
    
                Try {
                    
                    #Fetches group based on displayName
                    Write-Host "Looking up group..." -f Yellow
                    $GroupsLookup = Get-MgGroup -Filter "displayName eq '$Line'"
                    Write-Host "Assigning user to group $($Line.displayName)..." -f Yellow
                    New-MgGroupMember -GroupID $GroupsLookup.Id -DirectoryObjectId $UserId

                }
                Catch{
    
                    $e = $_Exception
                    $Line = $_.InvocationInfo.ScriptLineNumber
                    Write-Host "An error occurred at line $($Line):" -f Red
                    Write-Host "$_" -f Red
    
                }
    
        }
    
        }
        else {
            
            Write-Host "No file specified." -f Red
    
        }
    
    }
    elseif ($Group -ne $Null -and $Group -ne ""){
    
        Try {

            #Fetches group based on displayName
            Write-Host "Looking up group..." -f Yellow
            $GroupLookup = Get-MgGroup -Filter "DisplayName eq '$Group'"
            Write-Host "Assigning users to group..." -f Yellow
            New-MgGroupMember -GroupID $GroupLookup.Id -DirectoryObjectId $UserId.Id

        }
        Catch {
    
            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red
    
        }
    }

}