#!/bin/bash

# Prompt for the new user's name
read -p "Enter the new user's full name: " NAME

# Prompt for the new user's username
read -p "Enter the new user's username: " USERNAME

# Generate a random password for the new user
PASSWORD=$(openssl rand -base64 12)

# Create the new user with the given name and username
sudo dscl . -create /Users/$USERNAME RealName "$NAME"
sudo dscl . -create /Users/$USERNAME UserShell /bin/bash
sudo dscl . -create /Users/$USERNAME UniqueID "1001"
sudo dscl . -create /Users/$USERNAME PrimaryGroupID 80
sudo dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME

# Set the new user's password
sudo dscl . -passwd /Users/$USERNAME $PASSWORD

# Add the new user to the admin group
sudo dseditgroup -o edit -a $USERNAME -t user admin

echo "The new user '$USERNAME' has been created with the password '$PASSWORD'."
