#!/bin/bash
# This script seeds the database with sample data for testing.
# It should be run after 'database_setup.sh'.
# This version includes users, trains, schedules, and sample bookings.

# --- Configuration ---
DB_FILE="railway.db"

# --- Pre-flight Check ---
if [ ! -f "$DB_FILE" ]; then
    echo "Error: Database file '$DB_FILE' not found." >&2
    echo "Please run the database_setup.sh script first." >&2
    exit 1
fi

echo "Seeding database '$DB_FILE' with sample data..."

# --- Clear Existing Sample Data ---
# This prevents duplicating data if the script is run multiple times.
sqlite3 "$DB_FILE" <<'EOF'
DELETE FROM trains;
DELETE FROM schedules;
DELETE FROM bookings;
DELETE FROM users WHERE role = 'passenger';
-- Reset auto-increment counters for cleanliness after deletion
DELETE FROM sqlite_sequence WHERE name IN ('trains', 'schedules', 'bookings', 'users');
EOF

echo "Cleared existing sample data."

# --- Insert New Sample Data ---
sqlite3 "$DB_FILE" <<'EOF'

-- Insert Sample Passenger Users
INSERT INTO users (username, password_hash, full_name, role) VALUES
('john', 'pass123', 'John Doe', 'passenger'),
('jane', 'pass456', 'Jane Smith', 'passenger');

-- Insert Sample Trains
INSERT INTO trains (train_number, train_name, source_station, dest_station) VALUES
('12130', 'Azad Hind Express', 'Pune', 'Howrah'),
('22881', 'Pune-Bhubaneswar Express', 'Pune', 'Bhubaneswar'),
('11077', 'Jhelum Express', 'Pune', 'Jammu Tawi');

-- Insert Sample Schedules
-- train_id will be 1, 2, 3 based on insertion order.
INSERT INTO schedules (train_id, station_name, sleeper_seats, ac_seats) VALUES
(1, 'Pune', 150, 75),
(2, 'Pune', 120, 60),
(3, 'Pune', 200, 100);

-- #############################################################
-- ## NEW: Insert Sample Bookings for John and Jane           ##
-- #############################################################

-- Booking 1: A confirmed AC ticket for John on the Azad Hind Express
INSERT INTO bookings (pnr_number, user_id, train_id, travel_date, from_station, to_station, seat_class, status) VALUES
('20251020-84321', (SELECT user_id FROM users WHERE username = 'john'), (SELECT train_id FROM trains WHERE train_number = '12130'), '2025-10-20', 'Pune', 'Howrah', 'ac', 'CONFIRMED');

-- Booking 2: A cancelled Sleeper ticket for John on the Jhelum Express
INSERT INTO bookings (pnr_number, user_id, train_id, travel_date, from_station, to_station, seat_class, status) VALUES
('20251105-19874', (SELECT user_id FROM users WHERE username = 'john'), (SELECT train_id FROM trains WHERE train_number = '11077'), '2025-11-05', 'Pune', 'Jammu Tawi', 'sleeper', 'CANCELLED');

-- Booking 3: A confirmed Sleeper ticket for Jane on the Pune-Bhubaneswar Express
INSERT INTO bookings (pnr_number, user_id, train_id, travel_date, from_station, to_station, seat_class, status) VALUES
('20251215-55432', (SELECT user_id FROM users WHERE username = 'jane'), (SELECT train_id FROM trains WHERE train_number = '22881'), '2025-12-15', 'Pune', 'Bhubaneswar', 'sleeper', 'CONFIRMED');

EOF

# --- Check Command Success ---
if [ $? -eq 0 ]; then
    echo "Database successfully seeded with sample data, including bookings."
    exit 0
else
    echo "Error: Failed to seed database." >&2
    exit 1
fi
