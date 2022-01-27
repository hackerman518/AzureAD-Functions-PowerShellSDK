Function New-AADUser {

    [CmdletBinding()]
    Param(
    [Parameter(Mandatory = $True)]
    [String]$FName,
    [Parameter(Mandatory = $True)]
    [String]$LName,
    [Parameter()]
    [String]$Title,
    [Parameter()]
    [String]$Office,
    [Parameter()]
    [String]$Manager,
    [Parameter()]
    [String]$Dept,
    [Parameter()]
    [String]$Mobile,
    [Parameter()]
    [String]$Fax,
    [Parameter()]
    [String]$Group,
    [Parameter()]
    [Switch]$Multi,
    [Parameter()]
    [String]$File,
    [Parameter()]
    [Switch]$E3,
    [parameter()]
    [Switch]$E5,
    [Parameter()]
    [Switch]$ExchangeOnline,
    [Parameter()]
    [Switch]$PBIFree,
    [Parameter()]
    [Switch]$PBIPro,
    [Parameter()]
    [Switch]$Visio
    )

    <#
        IMPORTANT:
        ===========================================================================
        This script is provided 'as is' without any warranty. Any issues stemming 
        from use is on the user.
        ===========================================================================
		.DESCRIPTION
		Creates new AzureAD User, assigning specified licenses and groups

        Things to change to work for your environment:
        Line 147: add your company's domain name after @ for full email address
        Lines 158, 175, 192, 209: add your company name
        ===========================================================================
		.PARAMETER FName
		New user's first name
		.PARAMETER LName
        New user's last name
        .PARAMETER Title
        New user's title
        .PARAMETER Office
        New user's office location
        .PARAMETER Manager
        New user's manager
        .PARAMETER Dept
        New user's department
        .PARAMETER Mobile
        New user's mobile number, if applicable
        .PARAMETER Fax
        New user's Fax number, if applicable
        .PARAMETER Group
        Specifies displayname of a single group to add new user to
        .PARAMETER Multi
        Switch for adding new user to multiple groups
        .PARAMETER File
        Path to text file containing all the groups new user is to be added to
        .PARAMETER E3
        Switch that assigns Microsoft 365 E3 license to new user
        .PARAMETER E5
        Switch that assigns Microsoft 365 E5 license to new user
        .PARAMETER ExchangeOnline
        Switch that assigns Microsoft 365 ExchangeOnline license to new user
        .PARAMETER PBIFree
        Switch that assigns Microsoft 365 PowerBI (free) license to new user
        .PARAMETER PBIPro
        Switch that assigns Microsoft 365 PowerBI Pro license to new user
        .PARAMETER Visio
        Switch that assigns Microsoft 365 Visio license to new user
        ===========================================================================
		.EXAMPLE
		New-AADUser -FName Bob -LName Jameson -Title Sr. System's Administrator -Office CA -Manager alex@contoso.com -Dept IT -Mobile 999-999-9999 -Multi -File C:\Temp\Groups.txt -E5 -PBIPro -Visio
        ^--- The above example creates a new user named Bob Jameson, email bjameson@contoso.com, and assign the specified properties to him
	#>

#################################################

 #Ensuring the needed modules are installed
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Users")) {

        Install-Module -Name "Microsoft.Graph.Users" -Repository PSGallery -Force -AllowClobber

    }
    if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Users.Actions")) {

        Install-Module -Name "Microsoft.Graph.Users.Actions" -Repository PSGallery -Force -AllowClobber

    }
       if (-Not(Get-Module -ListAvailable -Name "Microsoft.Graph.Groups")) {

        Install-Module -Name "Microsoft.Graph.Groups" -Repository PSGallery -Force -AllowClobber

    }
    

#################################################

        #Generating a secure password
        Function GenerateStrongPassword ([Parameter(Mandatory = $true)][int]$PasswordLength){

            Add-Type -AssemblyName System.Web
            $PassComplexCheck = $false
            do{

                $newPassword = [System.Web.Security.Membership]::GeneratePassword($PasswordLength, 3)
                If (($newPassword -cmatch "[A-Z\p{Lu}\s]") `
                    -and ($newPassword -cmatch "[a-z\p{Ll}\s]") `
                    -and ($newPassword -match "[\d]") `
                    -and ($newPassword -match "[^\w]")
                )
                {
                    $PassComplexCheck = $True
                }

            }

            While ($PassComplexCheck -eq $false)
            return $newPassword

        }
        
    #################################################
    $Password = GenerateStrongPassword(12)
    Set-Clipboard -Value $Password


    #Creating the User
    $Initial = $FName.SubString(0,1)
    $Email = "$Initial$LName@.com"
    $PasswordProfile = @{

        Password = $Password

    }
    if ($Mobile -eq $Null -or $Mobile -eq "")
    {
        Try {

            Write-Host "Creating user..." -f Yellow
            New-MgUser -DisplayName "$FName $LName" -PasswordProfile $PasswordProfile -UserPrincipalName $Email -AccountEnabled:$true -MailNickName "$FName$LName" -CompanyName "" -Department $Dept -JobTitle $Title -OfficeLocation $Office -FaxNumber $Fax -UsageLocation "US"
        
        
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }
    }
    elseif ($Fax -eq $Null -or $Fax -eq "")
    {
        Try {

            Write-Host "Creating user..." -f Yellow
            New-MgUser -DisplayName "$FName $LName" -PasswordProfile $PasswordProfile -UserPrincipalName $Email -AccountEnabled:$true -MailNickName "$FName$LName" -CompanyName "" -Department $Dept -JobTitle $Title -MobilePhone $Mobile -OfficeLocation $Office -UsageLocation "US"
        
        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }
    }
    elseif (($Mobile -eq $Null -or $Mobile -eq "") -and ($Fax -eq $Null -or $Fax -eq ""))
    {
        Try {

            Write-Host "Creating user..." -f Yellow
            New-MgUser -DisplayName "$FName $LName" -PasswordProfile $PasswordProfile -UserPrincipalName $Email -AccountEnabled:$true -MailNickName "$FName$LName" -CompanyName "" -Department $Dept -JobTitle $Title -OfficeLocation $Office -UsageLocation "US"
        
        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }
    }
    else
    {
        Try {

            Write-Host "Creating user..." -f Yellow
            New-MgUser -DisplayName "$FName $LName" -PasswordProfile $PasswordProfile -UserPrincipalName $Email -AccountEnabled:$true -MailNickName "$FName$LName" -CompanyName "" -Department $Dept -JobTitle $Title -MobilePhone $Mobile -OfficeLocation $Office -FaxNumber $Fax -UsageLocation "US"
       
        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }
    }

    #################################################

    #Updating the manager
    $User = Get-MgUser -UserId $Email
    $Mgr = Get-MgUser -UserId $Manager
    $MgrUpdate = @{

        "@odata.id" = "https://grpah.microsoft.com/v1.0/users/$Mgr"

    }
    Try {

        Write-Host "Setting $($User.displayName)'s manager to $($Mgr.displayname)"
        Set-MgUserManagerByRef -UserId $User.Id -BodyParameter $MgrUpdate

    }
    Catch {

        $e = $_Exception
        $Line = $_.InvocationInfo.ScriptLineNumber
        Write-Host "An error occurred at line $($Line):" -f Red
        Write-Host "$_" -f Red

    }
    [System.Windows.Forms.MessageBox]::Show('Password copied to clipboard!', 'Password Generated', 'OK', 'Information')

    #################################################

    #Assigning Licenses
    If ($E3){

        Try {

            $E3SkuId = "05e9a617-0261-4cee-bb44-138d3ef5d965"
            Set-MgUserLicense -UserId $User.Id -AddLicenses @{SkuId = $E3SkuId} -RemoveLicenses @()

        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }

    }
    If ($E5){

        Try {

            $E5SkuId = "06ebc4ee-1bb5-47dd-8120-11324bc54e06"
            Set-MgUserLicense -UserId $User.Id -AddLicenses @{SkuId = $E5SkuId} -RemoveLicenses @()

        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }

    }
    If ($ExchangeOnline) {

        Try {

            $EOnlineSkuId = "4b9405b0-7788-4568-add1-99614e613b69"
            Set-MgUserLicense -UserId $User.Id -AddLicenses @{SkuId = $EOnlineSkuId} -RemoveLicenses @()

        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red
            
        }

    }
    If ($PBIFree){

        Try {

            $PBIFSkuId = "a403ebcc-fae0-4ca2-8c8c-7a907fd6c235"
            Set-MgUserLicense -UserId $User.id -AddLicenses @{SkuId = $PBIFSkuId} -RemoveLicenses @()

        }
        catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }

    }
    If ($PBIPro) {
        Try {

            $PBIPSkuId = "f8a1db68-be16-40ed-86d5-cb42ce701560"
            Set-MgUserLicense -UserId $User.id -AddLicenses @{SkuId = $PBIPSkuId} -RemoveLicenses @()

        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }

    }
    If ($Visio){

        Try {

            $VisioSkuId = "c5928f49-12ba-48f7-ada3-0d743a3601d5"
            Set-MgUserLicense -UserId $User.id -AddLicenses @{SkuId = $VisioSkuId} -RemoveLicenses @()

        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }

    }

    #################################################

    #Adding to groups

    If ($Multi) {

        If ($File -ne $Null -and $File -ne ""){

            $Fetch = Get-content $File
            foreach ($Line in $Fetch) {

                Try {
                    $GroupsLookup = Get-MgGroup -Filter "DisplayName eq '$Line'"
                    New-MgGroupMember -GroupID $GroupsLookup.Id -DirectoryObjectId $User.Id

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
            
            $GroupLookup = Get-MgGroup -Filter "DisplayName eq '$Group'"
            New-MgGroupMember -GroupID $GroupLookup.Id -DirectoryObjectId $User.Id

        }
        Catch {

            $e = $_Exception
            $Line = $_.InvocationInfo.ScriptLineNumber
            Write-Host "An error occurred at line $($Line):" -f Red
            Write-Host "$_" -f Red

        }
    }
}