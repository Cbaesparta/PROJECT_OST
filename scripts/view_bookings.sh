#!/bin/bash
# This script retrieves and displays all bookings for a specific user.
# It joins the bookings and trains tables to provide detailed information.
#
# Usage: ./scripts/view_bookings.sh <user_id>

# --- Configuration ---
DB_FILE="railway.db"

# --- Argument Validation ---
if [ "$#" -ne 1 ]; then
    echo "Error: A user ID is required." >&2
    echo "Usage: $0 <user_id>" >&2
    exit 1
fi

# --- Assign Arguments to Variables ---
USER_ID="$1"

# --- Pre-flight Check ---
if [ ! -f "$DB_FILE" ]; then
    echo "Error: Database file '$DB_FILE' not found." >&2
    echo "Please ensure you are in the project's root directory." >&2
    exit 1
fi

echo "Fetching bookings for User ID: $USER_ID"
echo "------------------------------------------------------------------------------------------------"

# --- Query Database and Format Output ---
# We perform a JOIN to get train details along with booking info.
# The -header option adds a title row to the output.
# The -column option formats the output into aligned columns.
bookings_found=$(sqlite3 -header -column "$DB_FILE" "
SELECT
  b.pnr_number AS 'PNR',
  t.train_number AS 'Train No.',
  t.train_name AS 'Train Name',
  b.travel_date AS 'Date',
  b.from_station AS 'From',
  b.to_station AS 'To',
  b.status AS 'Status'
FROM
  bookings AS b
JOIN
  trains AS t ON b.train_id = t.train_id
WHERE
  b.user_id = '$USER_ID';
")

# --- Display Results ---
if [ -z "$bookings_found" ]; then
    echo "No bookings found for this user."
else
    echo "$bookings_found"
fi

# --- Check Command Success ---
if [ $? -ne 0 ]; then
    echo "An error occurred while fetching bookings." >&2
    exit 1
fi

exit 0
