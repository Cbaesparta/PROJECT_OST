#!/bin/bash
# This script finds and lists available trains for a given route.
# It queries the 'trains' table in the database.
#
# Usage: ./scripts/search_trains.sh <source_station> <destination_station>

# --- Configuration ---
DB_FILE="railway.db"

# --- Argument Validation ---
if [ "$#" -ne 2 ]; then
    echo "Error: Incorrect number of arguments." >&2
    echo "Usage: $0 <source_station> <destination_station>" >&2
    exit 1
fi

# --- Assign Arguments to Variables ---
SOURCE_STATION="$1"
DESTINATION_STATION="$2"

# --- Pre-flight Check ---
if [ ! -f "$DB_FILE" ]; then
    echo "Error: Database file '$DB_FILE' not found." >&2
    echo "Please ensure you are in the project's root directory." >&2
    exit 1
fi

echo "Searching for trains from '$SOURCE_STATION' to '$DESTINATION_STATION'..."
echo "---------------------------------------------------------------------"

# --- Query Database and Format Output ---
# The LIKE operator with '%' allows for partial matches (e.g., 'Pune' will match 'Pune Jn').
# The -header option adds a title row to the output.
# The -column option formats the output into aligned columns.
trains_found=$(sqlite3 -header -column "$DB_FILE" "SELECT train_number AS 'Train No.', train_name AS 'Train Name', source_station AS 'Source', dest_station AS 'Destination' FROM trains WHERE source_station LIKE '%$SOURCE_STATION%' AND dest_station LIKE '%$DESTINATION_STATION%';")

# --- Display Results ---
if [ -z "$trains_found" ]; then
    echo "No direct trains found for this route."
else
    echo "$trains_found"
fi

# --- Check Command Success ---
if [ $? -ne 0 ]; then
    echo "An error occurred while searching the database." >&2
    exit 1
fi

exit 0
