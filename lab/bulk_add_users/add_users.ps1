# Import user details from CSV file
$users = Import-Csv -Path "C:\Path\To\Your\users.csv"

# Loop through each user and create an account
foreach ($user in $users) {
    # Set username and password variables
    $username = $user.Username
    $password = ConvertTo-SecureString $user.Password -AsPlainText -Force

    # Create new local user
    New-LocalUser -Name $username -Password $password -FullName $username -Description "Added by bulk script" -PasswordNeverExpires:$true

    # Add user to a specific group (e.g., Users group)
    Add-LocalGroupMember -Group "Users" -Member $username
}

Write-Output "User creation process completed."
