#!/bin/bash

# Define the GitHub username and folder name
USERNAME="<GitHub_username_here>"
FOLDER_NAME=$(date +"%Y%m%d")"-"${USERNAME}

# Create a folder with the current date and username
mkdir $FOLDER_NAME

# Get a list of all public repositories for the username using the GitHub API
REPOS=$(curl -s "https://api.github.com/users/${USERNAME}/repos" | grep -o '"full_name": "[^"]*' | awk -F'"' '{print $4}' | awk -F'/' '{print $2}')

# Loop through the repository names and download and unzip each one
for repo in ${REPOS}; do
  # Create a directory for the repository inside the folder
  mkdir "${FOLDER_NAME}/${repo}"
  
  # Download the ZIP file for the repository and save it in the repository directory
  curl -L "https://github.com/${USERNAME}/${repo}/archive/refs/heads/master.zip" -o "${FOLDER_NAME}/${repo}/${repo}.zip"
  
  # Unzip the contents of the ZIP file into the repository directory
  unzip -j "${FOLDER_NAME}/${repo}/${repo}.zip" -d "${FOLDER_NAME}/${repo}"
  
  # Remove the ZIP file
  rm "${FOLDER_NAME}/${repo}/${repo}.zip"
done
