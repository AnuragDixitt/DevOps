#!/bin/bash

# GitHub API base URL
API_URL="https://api.github.com"

# Check if required commands are available
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is not installed. Please install it to run this script."
    exit 1
fi

# Function to check if arguments are provided
function helper {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <REPO_OWNER> <REPO_NAME>"
        exit 1
    fi
}

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
    local collaborators

    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# --- Main script ---

# Check required arguments
helper "$@"

# User and Repository information
REPO_OWNER="$1"
REPO_NAME="$2"

# GitHub username and personal access token (should be set as environment variables)
USERNAME="${username}"
TOKEN="${token}"

# Validate credentials
if [[ -z "$USERNAME" || -z "$TOKEN" ]]; then
    echo "Error: GitHub username or token not set. Please export them as environment variables:"
    echo "  export username=YOUR_GITHUB_USERNAME"
    echo "  export token=YOUR_PERSONAL_ACCESS_TOKEN"
    exit 1
fi

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
