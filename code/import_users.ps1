# Custom script to import custom csv file of users

$Csvfile = "C:\Scripts\ad_users.csv"
$Users = Import-Csv $Csvfile


# Create Groups
foreach ($User in $Users) {
    $Group = $User.'Group'
    $Scope = "DomainLocal"

    $NewGroupParams = @{
        Name = $Group
        GroupScope = $Scope
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



# Loop through each user
foreach ($User in $Users) {
    $Name = $User.'Name'.split(" ")
    $Firstname = $Name[0]
    $Lastname = $Name[1]
    $Displayname = $User.'Name'
    $InitialSamAccountName = $Firstname[0] + $Lastname
    $SamAccountName = $InitialSamAccountName.ToLower()
    $InitialUserPrincipalName = "$SamAccountName@xyz.com"
    $UserPrincipalName = $InitialUserPrincipalName.ToLower()
    $Email = "$Firstname.$Lastname@xyz.com"
    $Street = $User.'Street'
    $City = $User.'City'
    $State = $User.'State'
    $ZIP = $User.'ZIP'
    $Country = $User.'Country'
    $Title = $User.'Title'
    $Department = $User.'Department'
    $Mobile = $User.'Phone Number'
    $Password = $User.'Password'
    $Group = $User.'Group'


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



    # Create parameters for each user to join group
    $UsertoGroupParams = @{
        Identity = $Group
        Members = $SamAccountName
    }


    try {
        # Add users to groups
        Add-ADGroupMember @UsertoGroupParams
        Write-Host "User $SamAccountName added successfully to $Group." -ForegroundColor Green
    }
    catch {
        #Show error if failed
        $ErrorMessage = $_.Exception.Message
        Write-Warning "Failed to add $SamAccountName to $Group. $_"
    }
}