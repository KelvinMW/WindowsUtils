# Import user details from CSV file
$users = Import-Csv -Path "C:\Path\To\Your\users.csv"

# Loop through each user and create or update the account
foreach ($user in $users) {
    # Set username, password, full name, and description variables
    $username = $user.Username
    $password = ConvertTo-SecureString $user.Password -AsPlainText -Force
    $fullname = $user.FullName
    $description = $user.Description

    # Check if the user already exists
    $existingUser = Get-LocalUser -Name $username -ErrorAction SilentlyContinue

    if ($existingUser) {
        Write-Output "User '$username' already exists. Updating details."

        # Update existing user with new password, full name, and description
        Set-LocalUser -Name $username -Password $password -FullName $fullname -Description $description
        
        Write-Output "User '$username' updated successfully."
    } else {
        Write-Output "User '$username' does not exist. Creating new user."

        # Create new local user with full name and description
        New-LocalUser -Name $username -Password $password -FullName $fullname -Description $description -PasswordNeverExpires:$true
        
        Write-Output "User '$username' created successfully."
    }

    # Add user to the 'Users' group
    Add-LocalGroupMember -Group "Users" -Member $username

    # Add user to the 'Remote Desktop Users' group
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member $username
}

Write-Output "User creation and update process completed."
