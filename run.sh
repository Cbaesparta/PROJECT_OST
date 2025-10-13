#!/bin/bash
# This script is the main entry point to start the Railway Ticketing System.
# It ensures the main menu script is executable and then runs it.

# --- Configuration ---
MENU_SCRIPT="menu.sh"

# --- Pre-flight Check ---
# Check if the main menu script exists in the current directory.
if [ ! -f "$MENU_SCRIPT" ]; then
    echo "Error: Main menu script ('$MENU_SCRIPT') not found." >&2
    echo "Please ensure you are running this script from the project's root directory." >&2
    exit 1
fi

# --- Ensure Executability ---
# Check if the menu script has execute permissions, and add them if it doesn't.
if [ ! -x "$MENU_SCRIPT" ]; then
    echo "Notice: '$MENU_SCRIPT' is not executable. Adding permissions..."
    chmod +x "$MENU_SCRIPT"
fi

# --- Launch Application ---
# Execute the main menu script, passing along any arguments if necessary.
./"$MENU_SCRIPT" "$@"

# Exit with the same status code that the menu script returned.
exit $?

