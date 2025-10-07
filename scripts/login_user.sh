#!/bin/bash
# Implements user login authentication for the backend.
# It queries the database and exits with 0 on success or 1 on failure.
#
# Usage: ./scripts/login_user.sh <username> <password>

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
# We select the user_id to check for existence.
# In a real system, the password would be hashed and compared securely.
user_data=$(sqlite3 "$DB_FILE" "SELECT user_id FROM users WHERE username = '$USERNAME' AND password_hash = '$PASSWORD';")

# --- Check Result and Exit ---
if [ -z "$user_data" ]; then
    # If the query returned nothing (the variable is empty), the login is invalid.
    echo "Error: Invalid username or password." >&2
    exit 1 # Exit with failure status
else
    # If the query returned a user_id, the login is successful.
    echo "Login successful."
    exit 0 # Exit with success status
fi
