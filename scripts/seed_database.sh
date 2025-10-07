#!/bin/bash
# This script seeds the database with sample data for testing.
# It should be run after 'database_setup.sh'.
# It clears previous sample data (except for the admin user) before inserting new data.

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
# It carefully preserves the 'admin' user created during initial setup.
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
# Using a heredoc to pass multiple SQL commands to sqlite3.
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
-- Note: train_id will be 1, 2, 3 based on the insertion order above.
-- Schedules for Azad Hind Express (train_id = 1)
INSERT INTO schedules (train_id, station_name, arrival_time, departure_time, sleeper_seats, ac_seats) VALUES
(1, 'Pune', NULL, '18:45', 150, 75),
(1, 'Daund', '19:50', '19:55', 150, 75),
(1, 'Manmad', '00:15', '00:20', 150, 75),
(1, 'Nagpur', '09:50', '09:55', 150, 75),
(1, 'Howrah', '03:55', NULL, 150, 75);

-- Schedules for Pune-Bhubaneswar Express (train_id = 2)
INSERT INTO schedules (train_id, station_name, arrival_time, departure_time, sleeper_seats, ac_seats) VALUES
(2, 'Pune', NULL, '22:25', 120, 60),
(2, 'Solapur', '02:20', '02:25', 120, 60),
(2, 'Secunderabad', '08:15', '08:30', 120, 60),
(2, 'Bhubaneswar', '04:15', NULL, 120, 60);

-- Schedules for Jhelum Express (train_id = 3)
INSERT INTO schedules (train_id, station_name, arrival_time, departure_time, sleeper_seats, ac_seats) VALUES
(3, 'Pune', NULL, '17:20', 200, 100),
(3, 'Bhopal', '08:25', '08:35', 200, 100),
(3, 'New Delhi', '19:50', '20:05', 200, 100),
(3, 'Jammu Tawi', '05:00', NULL, 200, 100);

EOF

# --- Check Command Success ---
if [ $? -eq 0 ]; then
    echo "Database successfully seeded with sample data."
    exit 0
else
    echo "Error: Failed to seed database." >&2
    exit 1
fi
