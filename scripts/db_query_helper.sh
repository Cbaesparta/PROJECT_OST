#!/bin/bash
# This is a helper script to execute SQL queries against the database.
# It centralizes the sqlite3 command for cleaner, more maintainable code.
#
# Usage: ./scripts/db_query_helper.sh "SELECT * FROM users;"

# --- Configuration ---
DB_FILE="railway.db"

# --- Argument Validation ---
if [ "$#" -ne 1 ]; then
    echo "Error: This script requires a single SQL query as an argument." >&2
    echo "Usage: $0 \"<SQL_QUERY>\"" >&2
    exit 1
fi

# --- Assign Argument to Variable ---
SQL_QUERY="$1"

# --- Pre-flight Check ---
if [ ! -f "$DB_FILE" ]; then
    echo "Error: Database file '$DB_FILE' not found." >&2
    exit 1
fi

# --- Execute Query ---
# The -header and -column flags are used for nicely formatted output.
# Other scripts can then process this raw output as needed.
sqlite3 -header -column "$DB_FILE" "$SQL_QUERY"

# --- Check Command Success ---
if [ $? -ne 0 ]; then
    echo "Error: The SQL query failed to execute." >&2
    exit 1
fi

exit 0
