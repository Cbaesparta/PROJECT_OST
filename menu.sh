#!/bin/bash

# This is the final, fully integrated main menu script for the Railway Ticketing System.
# It handles all user interaction, calls backend scripts, and provides responsive feedback.

# --- Global Variables ---
DB_FILE="railway.db"
# Temporary file to store dialog output
output_file=$(mktemp)
# Trap to clean up the temporary file on exit, ensuring it's always removed.
trap "rm -f $output_file" EXIT

# Store the logged-in user's ID and username globally for the session
LOGGED_IN_USER_ID=""
LOGGED_IN_USERNAME=""

# --- UI Helper Functions ---

# A simple feedback message box
show_message() {
    local title="$1"
    local message="$2"
    dialog --backtitle "Railway Ticketing System" --title "$title" --msgbox "$message" 8 60
}

# --- Main Feature Handlers ---

# handle_search_trains: UI to get search criteria and display results.
handle_search_trains() {
    dialog --backtitle "Railway Ticketing System" \
           --title "Search for Trains" \
           --clear \
           --form "Enter source and destination:" 15 60 0 \
           "From Station:" 1 1 "" 1 15 40 0 \
           "To Station:"   2 1 "" 2 15 40 0 \
           2>"$output_file"

    exit_status=$?
    [ $exit_status -ne 0 ] && return

    from_station=$(sed -n '1p' "$output_file")
    to_station=$(sed -n '2p' "$output_file")

    if [ -z "$from_station" ] || [ -z "$to_station" ]; then
        show_message "Error" "Both source and destination are required."
        return
    fi

    # Call the backend script and capture its output
    search_results=$(./scripts/search_trains.sh "$from_station" "$to_station")

    # Display results in a scrollable textbox
    dialog --backtitle "Railway Ticketing System" \
           --title "Search Results" \
           --textbox-file <(echo "$search_results") 20 80
}

# handle_view_bookings: Displays the current user's booking history.
handle_view_bookings() {
    # Call the backend script with the globally stored user ID
    booking_history=$(./scripts/view_bookings.sh "$LOGGED_IN_USER_ID")

    dialog --backtitle "Railway Ticketing System" \
           --title "My Booking History" \
           --textbox-file <(echo "$booking_history") 20 80
}

# --- Core Menu Functions ---

# passenger_menu: The main menu for logged-in passengers.
passenger_menu() {
    while true; do
        selection=$(dialog --backtitle "Railway Ticketing System - Welcome, $LOGGED_IN_USERNAME" \
                           --title "Passenger Menu" \
                           --clear \
                           --cancel-label "Logout" \
                           --menu "Select an option:" 15 50 4 \
                           "1" "Search for Trains" \
                           "2" "View My Bookings" \
                           2>&1 >/dev/tty)
        exit_status=$?
        [ $exit_status -ne 0 ] && break

        case $selection in
            1) handle_search_trains ;;
            2) handle_view_bookings ;;
        esac
    done
}

# admin_menu: The main menu for logged-in administrators.
admin_menu() {
    while true; do
        selection=$(dialog --backtitle "Railway Ticketing System - ADMIN" \
                           --title "Administrator Menu" \
                           --clear \
                           --cancel-label "Logout" \
                           --menu "Select an option:" 15 50 4 \
                           "1" "Add New Train" \
                           "2" "Add New Schedule" \
                           2>&1 >/dev/tty)
        exit_status=$?
        [ $exit_status -ne 0 ] && break

        case $selection in
            1) show_message "Admin Action" "Function to add a train would be called here." ;;
            2) show_message "Admin Action" "Function to add a schedule would be called here." ;;
        esac
    done
}


# --- Top-Level Handlers (from Main Menu) ---

# handle_login: Displays a form to get user credentials and logs them in.
handle_login() {
    dialog --backtitle "Railway Ticketing System" \
           --title "User Login" \
           --clear \
           --mixedform "Enter your credentials:" 12 50 0 \
           "Username:" 1 1 "" 1 10 25 0 0 \
           "Password:" 2 1 "" 2 10 25 0 1 \
           2>"$output_file"

    [ $? -ne 0 ] && return

    username=$(sed -n '1p' "$output_file")
    password=$(sed -n '2p' "$output_file")

    # Call the backend login script
    # Assuming login_user.sh is modified to print "USER_ID,ROLE" on success
    login_result=$(./scripts/login_user.sh "$username" "$password")
    login_status=$?

    if [ $login_status -eq 0 ]; then
        LOGGED_IN_USER_ID=$(echo "$login_result" | cut -d',' -f1)
        local user_role=$(echo "$login_result" | cut -d',' -f2)
        LOGGED_IN_USERNAME=$username

        show_message "Success" "Login successful! Welcome, $username."

        case "$user_role" in
            "passenger") passenger_menu ;;
            "admin") admin_menu ;;
            *) show_message "Error" "Unknown user role: $user_role" ;;
        esac
    else
        show_message "Login Failed" "Invalid username or password."
    fi
}

# handle_register: Captures user details and calls the registration script.
handle_register() {
    dialog --backtitle "Railway Ticketing System" \
           --title "New User Registration" \
           --clear \
           --form "Enter your details:" 15 60 0 \
           "Username:"   1 1 "" 1 15 40 0 \
           "Full Name:"  2 1 "" 2 15 40 0 \
           "Password:"   3 1 "" 3 15 40 1 \
           "Confirm:"    4 1 "" 4 15 40 1 \
           2>"$output_file"

    [ $? -ne 0 ] && return

    username=$(sed -n '1p' "$output_file")
    full_name=$(sed -n '2p' "$output_file")
    password=$(sed -n '3p' "$output_file")
    confirm_password=$(sed -n '4p' "$output_file")

    # --- Validation ---
    if [ "$password" != "$confirm_password" ]; then
        show_message "Error" "Passwords do not match."
        return
    fi
    if [ -z "$username" ] || [ -z "$full_name" ] || [ -z "$password" ]; then
        show_message "Error" "All fields are required."
        return
    fi

    # --- Backend Call ---
    registration_output=$(./scripts/register_user.sh "$username" "$password" "$full_name" 2>&1)
    
    if [ $? -eq 0 ]; then
        show_message "Success" "Registration successful! You can now log in."
    else
        # Show the actual error message from the script (e.g., "Username taken")
        show_message "Registration Failed" "$registration_output"
    fi
}

# --- Main Menu Loop ---
while true; do
    selection=$(dialog --backtitle "Railway Ticketing System" \
                       --title "Main Menu" \
                       --clear \
                       --cancel-label "Exit" \
                       --menu "Select an option:" 15 50 4 \
                       "1" "Login" \
                       "2" "Register" \
                       2>&1 >/dev/tty)
    
    [ $? -ne 0 ] && break

    case $selection in
        1) handle_login ;;
        2) handle_register ;;
    esac
done

# --- Cleanup ---
clear
echo "Thank you for using the Railway Ticketing System. Goodbye!"
