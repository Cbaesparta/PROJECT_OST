#!/bin/bash
# Implements user login authentication for the backend.
# It queries the database, and on success, prints the "user_id,role"
# and exits with 0. On failure, it exits with 1.

# --- Configuration ---
DB_FILE="railway.db"

# --- Argument Validation ---
if [ "$#" -ne 2 ]; then
    echo "Error: Missing arguments." >&2
    echo "Usage: $0 <username> <password>" >&2
    exit 1
fi

# --- Assign Arguments to Variables ---
USERNAME="$1"
PASSWORD="$2"

# --- Query Database to Verify Credentials ---
# We select the user_id and role to check for existence and to return on success.
# The output from sqlite3 will be like "2|passenger"
user_data=$(sqlite3 "$DB_FILE" "SELECT user_id, role FROM users WHERE username = '$USERNAME' AND password_hash = '$PASSWORD';")

# --- Check Result and Exit ---
if [ -z "$user_data" ]; then
    # If the query returned nothing, the login is invalid.
    # The error message goes to stderr so the menu doesn't see it.
    echo "Error: Invalid username or password." >&2
    exit 1 # Exit with failure status
else
    # If the query returned data, the login is successful.
    # Print the user_id and role, replacing the '|' from sqlite with a comma.
    # This is the data the menu.sh script is expecting.
    echo "$user_data" | tr '|' ','
    exit 0 # Exit with success status
fi
