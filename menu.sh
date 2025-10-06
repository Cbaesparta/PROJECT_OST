#!/bin/bash

# Main entry point for the Railway Ticketing System.
# This script handles the initial user interaction (Login/Register)
# and then directs them to the appropriate menu.
#
# Make sure 'dialog' is installed:
# sudo apt install dialog

# --- Global Constants & Configuration ---
DB_FILE="railway.db"
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

# --- Function Definitions ---

# A helper function to display a simple message box.
# $1: Title, $2: Message
display_msgbox() {
  dialog --title "$1" --msgbox "$2" 8 50
}

# --- Placeholder Functions for Backend Scripts ---
# These functions will eventually call the real backend scripts.

# Handles the user registration process.
handle_register() {
  # The UI developer will build the form here to collect user details.
  # For now, it's a placeholder.
  
  # TODO: Call a dialog form to get username, password, and full name.
  # TODO: Call the backend script: ./register_user.sh "$username" "$password" "$full_name"
  # TODO: Check the exit code of the script and display a success/failure message.
  
  display_msgbox "Register" "User registration feature is under development."
}

# Handles the user login process.
handle_login() {
  # The UI developer will build the form here to get credentials.
  
  # TODO: Call a dialog form to get username and password.
  # TODO: Call the backend script: ./login_user.sh "$username" "$password"
  # TODO: Check the exit code. If successful (0), then call passenger_menu.
  #       Otherwise, show an error message.
  
  # For demonstration, we will assume login is successful and go to the passenger menu.
  display_msgbox "Login" "Login successful! Welcome, User."
  passenger_menu # Proceed to the main menu for logged-in users.
}

# --- Menus for Different User Roles ---

# Displays the main menu for a logged-in passenger.
passenger_menu() {
  while true; do
    exec 3>&1
    selection=$(dialog \
      --backtitle "Railway Ticketing System" \
      --title "Passenger Menu" \
      --clear \
      --cancel-label "Logout" \
      --menu "Please select an option:" $HEIGHT $WIDTH 4 \
      "1" "Book a Ticket" \
      "2" "Cancel a Ticket" \
      "3" "View My Bookings" \
      2>&1 1>&3)
    exit_status=$?
    exec 3>&-

    case $exit_status in
      $DIALOG_CANCEL) # This is the "Logout" button
        clear
        display_msgbox "Logout" "You have been successfully logged out."
        return # Return to the initial welcome/login menu
        ;;
      $DIALOG_ESC)
        clear
        echo "Program aborted." >&2
        exit 1
        ;;
    esac

    case $selection in
      1)
        # TODO: Call a script or function to handle booking.
        display_msgbox "Book Ticket" "Booking feature is under development."
        ;;
      2)
        # TODO: Call a script or function to handle cancellation.
        display_msgbox "Cancel Ticket" "Cancellation feature is under development."
        ;;
      3)
        # TODO: Call a script or function to view bookings.
        display_msgbox "View Bookings" "View bookings feature is under development."
        ;;
    esac
  done
}

# --- Main Application Loop (Initial Entry Point) ---
while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Railway Ticketing System - Welcome" \
    --title "Main Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select an option:" $HEIGHT $WIDTH 3 \
    "1" "Login" \
    "2" "Register" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

  case $exit_status in
    $DIALOG_CANCEL | $DIALOG_ESC)
      clear
      echo "Program terminated."
      exit 0
      ;;
  esac

  case $selection in
    1)
      handle_login
      ;;
    2)
      handle_register
      ;;
  esac
done


