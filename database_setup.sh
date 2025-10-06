#!/bin/bash

# This script initializes the SQLite database for the Railway Ticketing System.
# It creates the database file and defines the schema for all necessary tables.
# Run this script once at the beginning of the project.

# --- Configuration ---
DB_FILE="railway.db"

# --- Safety Check ---
# Check if the database file already exists.
if [ -f "$DB_FILE" ]; then
  echo "Database file '$DB_FILE' already exists."
  read -p "Do you want to delete it and start over? (y/n): " choice
  case "$choice" in
    y|Y )
      rm "$DB_FILE"
      echo "Existing database file removed."
      ;;
    * )
      echo "Exiting without creating a new database."
      exit 1
      ;;
  esac
fi

echo "Creating database schema in '$DB_FILE'..."

# --- Create Tables using SQLite3 ---
# The 'EOF' heredoc allows us to pass multiple SQL commands to sqlite3.
sqlite3 "$DB_FILE" <<'EOF'

-- Table: users
-- Stores information about registered passengers and administrators.
CREATE TABLE users (
    user_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    username    TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    full_name   TEXT,
    role        TEXT NOT NULL CHECK(role IN ('passenger', 'admin'))
);

-- Table: trains
-- Stores details for each train in the system.
CREATE TABLE trains (
    train_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    train_number    TEXT NOT NULL UNIQUE,
    train_name      TEXT NOT NULL,
    source_station  TEXT NOT NULL,
    dest_station    TEXT NOT NULL
);

-- Table: schedules
-- Stores the route, timing, and seat availability for each train.
CREATE TABLE schedules (
    schedule_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    train_id        INTEGER NOT NULL,
    station_name    TEXT NOT NULL,
    arrival_time    TEXT, -- Format HH:MM
    departure_time  TEXT, -- Format HH:MM
    sleeper_seats   INTEGER NOT NULL DEFAULT 0,
    ac_seats        INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(train_id) REFERENCES trains(train_id)
);

-- Table: bookings
-- Stores records of all tickets booked by users.
CREATE TABLE bookings (
    booking_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    pnr_number      TEXT NOT NULL UNIQUE,
    user_id         INTEGER NOT NULL,
    train_id        INTEGER NOT NULL,
    travel_date     TEXT NOT NULL, -- Format YYYY-MM-DD
    from_station    TEXT NOT NULL,
    to_station      TEXT NOT NULL,
    seat_class      TEXT NOT NULL CHECK(seat_class IN ('sleeper', 'ac')),
    status          TEXT NOT NULL CHECK(status IN ('CONFIRMED', 'CANCELLED')),
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(train_id) REFERENCES trains(train_id)
);

-- Insert an initial admin user for easy access.
-- In a real application, the password would be properly hashed during registration.
INSERT INTO users (username, password_hash, full_name, role)
VALUES ('admin', 'adminpass', 'Administrator', 'admin');

EOF

echo "Database '$DB_FILE' created and schema initialized successfully."
echo "An initial user 'admin' with password 'adminpass' has been created."
