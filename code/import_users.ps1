# Custom script to impoot csv file of users
#
# You will need to edit certain lines to customize for your own company, OUs, and Security Groups
#
# 04/21/2024 - May god be with us all, cuz idk what the fuck i'm doing

# Custom Variables
$DomainName = "jlab.lcl" # Enter your domain name including TLD, eg "google.com"
$CompanyName = "JLAB Technologies" # Enter your company name, this will be used to create the top level custom OU

$DomainNameSplit = $DomainName.split(".")
$Domain = $DomainNameSplit[0]
$DomainTLD = $DomainNameSplit[1]

$Csvfile = ".\ad_users.csv"
$Users = Import-Csv $Csvfile


# Create Parent OU
New-ADOrganizationalUnit -Name $CompanyName -Path "DC=$Domain,DC=$DomainTLD"
New-ADOrganizationalUnit -Name "Users" -Path "OU=$CompanyName,DC=$Domain,DC=$DomainTLD"
New-ADOrganizationalUnit -Name "Security Groups" -Path "OU=$CompanyName,DC=$Domain,DC=$DomainTLD"


# Create OUs
foreach ($User in $Users) {
    $CustomOU = $User.'OU'

    try {
    New-ADOrganizationalUnit -Name $CustomOU -Path "OU=Users,OU=$CompanyName,DC=$Domain,DC=$DomainTLD"
    }
    catch {
    # Show error message if failed
    $ErrorMessage = $_.Exception.Message
    Write-Warning "Failed to create OU $CustomOU. $_"
    }
}


# Create Security Groups
foreach ($User in $Users) {
    $SecurityGroup = $User.'Department'
    $Scope = "DomainLocal"

    $NewGroupParams = @{
        Name = $SecurityGroup
        GroupScope = $Scope
        Path = "OU=Security Groups,OU=$CompanyName,DC=$Domain,DC=$DomainTLD"
    }

    try {
    New-ADGroup @NewGroupParams
    }
    catch {
    # Show error message if failed
    $ErrorMessage = $_.Exception.Message
    Write-Warning "Failed to create Group $Group. $_"
    }
}


# Loop through each user, creating the account and assigning them to a Group
foreach ($User in $Users) {
    $Name = $User.'Name'.split(" ")
    $Firstname = $Name[0]
    $Lastname = $Name[1]
    $Displayname = $User.'Name'
    $InitialSamAccountName = $Firstname[0] + $Lastname
    $SamAccountName = $InitialSamAccountName.ToLower()
    $InitialUserPrincipalName = "$SamAccountName@$DomainName"
    $UserPrincipalName = $InitialUserPrincipalName.ToLower()
    $Email = "$Firstname.$Lastname@$DomainName"
    $Street = $User.'Street'
    $City = $User.'City'
    $State = $User.'State'
    $ZIP = $User.'ZIP'
    $Country = $User.'Country'
    $Title = $User.'Title'
    $Department = $User.'Department'
    $Mobile = $User.'Phone Number'
    $Password = $User.'Password'
    $CustomOU = $User.'OU'



    # Create parameters for each new user
    $NewUserParams = @{
        Name = $Displayname
        GivenName = $Firstname
        Surname = $Lastname
        Displayname = $Displayname
        SamAccountName = $SamAccountName
        UserPrincipalName = $UserPrincipalName
        EmailAddress = $Email
        StreetAddress = $Street
        City = $City
        State = $State
        PostalCode = $ZIP
        Country = $Country
        Title = $Title
        Department = $Department
        MobilePhone = $Mobile
        AccountPassword = (ConvertTo-SecureString $Password -AsPlainText -Force)
        PasswordNeverExpires = $true
        Enabled = $true
        Path = "OU=$CustomOU,OU=Users,OU=$CompanyName,DC=$Domain,DC=$DomainTLD"
    }

    try {
        # Add users
        New-ADUser @NewUserParams
        Write-Host "User $SamAccountName created successfully." -ForegroundColor Green
    }
    catch {
        # Show error message if failed
        $ErrorMessage = $_.Exception.Message
        Write-Warning "Failed to create user $SamAccountName. $_"
    }



    # Join each user to their designated group
    $UsertoGroupParams = @{
        Identity = $Department
        Members = $SamAccountName
    }

    try {
        # Add users to groups
        Add-ADGroupMember @UsertoGroupParams
        Write-Host "User $SamAccountName added successfully to $Department." -ForegroundColor Green
    }
    catch {
        #Show error if failed
        $ErrorMessage = $_.Exception.Message
        Write-Warning "Failed to add $SamAccountName to $Department. $_"
    }
}