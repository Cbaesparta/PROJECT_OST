#!/bin/bash

# This script handles new user registration.
# It checks if the username is already taken and, if not,
# inserts the new user into the database.

# --- Configuration ---
DB_FILE="railway.db"

# --- Argument Validation ---
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <username> <password> <full_name>" >&2
    exit 1
fi

# --- Assign Arguments to Variables ---
USERNAME="$1"
PASSWORD="$2"
FULL_NAME="$3"
ROLE="passenger" # Default role for new registrations

# --- Check for Existing User ---
# Query the database to see if a user with this username already exists.
# The -cmd ".quit" is used to prevent the sqlite3 shell from staying open.
existing_user=$(sqlite3 "$DB_FILE" "SELECT user_id FROM users WHERE username = '$USERNAME';")

if [ -n "$existing_user" ]; then
    # If the query returned anything, the user exists.
    # We send the error message to standard error (>&2).
    echo "Error: Username '$USERNAME' is already taken." >&2
    exit 1 # Exit with a failure status
fi

# --- Insert New User ---
# If the script gets here, the username is available.
# NOTE: In a production system, you MUST hash the password.
# For this project, we are storing it as plain text for simplicity.
sqlite3 "$DB_FILE" <<EOF
INSERT INTO users (username, password_hash, full_name, role)
VALUES ('$USERNAME', '$PASSWORD', '$FULL_NAME', '$ROLE');
EOF

# --- Check Command Success ---
# Check the exit status of the last command (the sqlite3 insert).
if [ $? -eq 0 ]; then
    echo "User '$USERNAME' registered successfully."
    exit 0 # Exit with a success status
else
    echo "Error: Failed to register user. An unknown database error occurred." >&2
    exit 1 # Exit with a failure status
fi

