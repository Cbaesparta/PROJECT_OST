#!/bin/bash

# FINAL PRODUCTION-READY - Railway Ticketing System Main Menu

# --- Global Variables ---
DB_FILE="railway.db"
LOGGED_IN_USER_ID=""
LOGGED_IN_USERNAME=""

# --- Ensures Required Files Exist ---
for f in "$DB_FILE" ./scripts/search_trains.sh ./scripts/view_bookings.sh ./scripts/login_user.sh ./scripts/register_user.sh; do
    if ! [ -e "$f" ]; then
        echo "Missing required file: $f"
        exit 1
    fi
done

# --- Handle Interrupts ---
trap 'clear; echo "Session interrupted. Goodbye!"; exit' SIGINT SIGTERM

# --- UI Helper Functions ---
show_message() {
    local title="$1"
    local message="$2"
    dialog --backtitle "Railway Ticketing System" --title "$title" --msgbox "$message" 8 60
}

# --- Core Feature Handlers ---
handle_search_trains() {
    local from_station to_station search_results
    from_station=$(dialog --clear --backtitle "Railway Ticketing System" --title "Search Trains" --inputbox "Enter From Station:" 8 40 2>&1 >/dev/tty)
    [ $? -ne 0 ] && return
    to_station=$(dialog --clear --backtitle "Railway Ticketing System" --title "Search Trains" --inputbox "Enter To Station:" 8 40 2>&1 >/dev/tty)
    [ $? -ne 0 ] && return

    if [ -z "$from_station" ] || [ -z "$to_station" ]; then
        show_message "Error" "Both source and destination are required."
        return
    fi

    search_results=$(./scripts/search_trains.sh "$from_station" "$to_station" 2>&1)
    dialog --backtitle "Railway Ticketing System" --title "Search Results" --msgbox "$search_results" 20 80
}

handle_view_bookings() {
    local booking_history
    booking_history=$(./scripts/view_bookings.sh "$LOGGED_IN_USER_ID" 2>&1)
    dialog --backtitle "Railway Ticketing System" --title "My Booking History" --msgbox "$booking_history" 20 80
}

# --- Core Menu Functions ---
passenger_menu() {
    while true; do
        selection=$(dialog --backtitle "Railway Ticketing System - Welcome, $LOGGED_IN_USERNAME" \
                           --title "Passenger Menu" --clear \
                           --cancel-label "Logout" \
                           --menu "Select an option:" 15 50 4 \
                           "1" "Search for Trains" \
                           "2" "View My Bookings" \
                           2>&1 >/dev/tty)
        [ $? -ne 0 ] && break
        case "$selection" in
            1) handle_search_trains ;;
            2) handle_view_bookings ;;
        esac
    done
}

admin_menu() {
    show_message "Admin Menu" "Admin features are under development."
}

# --- Top-Level Handlers (from Main Menu) ---
handle_login() {
    local username password login_result login_status user_role
    username=$(dialog --clear --backtitle "Railway Ticketing System" --title "User Login" --inputbox "Enter Username:" 8 40 2>&1 >/dev/tty)
    [ $? -ne 0 ] && return

    # --- PASSWORD INPUT USING 'read -s' ---
    clear
    echo "Railway Ticketing System - User Login"
    echo "-------------------------------------"
    echo "Username: $username"
    echo -n "Enter Password: "
    read -s password
    echo

    if [ -z "$password" ]; then
        show_message "Cancelled" "Login cancelled."
        return
    fi

    login_result=$(./scripts/login_user.sh "$username" "$password")
    login_status=$?

    if [ $login_status -eq 0 ]; then
        LOGGED_IN_USER_ID=$(echo "$login_result" | cut -d',' -f1)
        user_role=$(echo "$login_result" | cut -d',' -f2)
        LOGGED_IN_USERNAME="$username"
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

handle_register() {
    local username full_name password confirm_password registration_output
    username=$(dialog --clear --backtitle "Railway Ticketing System" --title "New User Registration" --inputbox "Enter a new Username:" 8 40 2>&1 >/dev/tty)
    [ $? -ne 0 ] && return
    full_name=$(dialog --clear --backtitle "Railway Ticketing System" --title "New User Registration" --inputbox "Enter your Full Name:" 8 40 2>&1 >/dev/tty)
    [ $? -ne 0 ] && return

    clear
    echo "Railway Ticketing System - New User Registration"
    echo "---------------------------------------------"
    echo "Username: $username"
    echo "Full Name: $full_name"
    echo -n "Enter Password: "
    read -s password
    echo

    echo -n "Confirm Password: "
    read -s confirm_password
    echo

    if [ "$password" != "$confirm_password" ]; then
        show_message "Error" "Passwords do not match."
        return
    fi
    if [ -z "$username" ] || [ -z "$full_name" ] || [ -z "$password" ]; then
        show_message "Error" "All fields are required."
        return
    fi

    registration_output=$(./scripts/register_user.sh "$username" "$password" "$full_name" 2>&1)
    if [ $? -eq 0 ]; then
        show_message "Success" "Registration successful! You can now log in."
    else
        show_message "Registration Failed" "$registration_output"
    fi
}

# --- Main Menu Loop ---
while true; do
    selection=$(dialog --clear --backtitle "Railway Ticketing System" \
                       --title "Main Menu" \
                       --cancel-label "Exit" \
                       --menu "Select an option:" 15 50 4 \
                       "1" "Login" \
                       "2" "Register" \
                       2>&1 >/dev/tty)
    [ $? -ne 0 ] && break
    case "$selection" in
        1) handle_login ;;
        2) handle_register ;;
    esac
done

# --- Cleanup ---
clear
echo "Thank you for using the Railway Ticketing System. Goodbye!"
