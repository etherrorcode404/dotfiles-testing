#!/bin/bash

BACKUP_FILE="installed_packages.list"

# Function to back up installed packages
backup_packages() {
    echo "Backing up installed packages... 📦"
    dpkg --get-selections > "$BACKUP_FILE"
    echo "Backup saved as $BACKUP_FILE ✅"
}

# Function to restore packages on another machine
restore_packages() {
    if [[ ! -f "$BACKUP_FILE" ]]; then
        echo "Error: Backup file $BACKUP_FILE not found! ❌"
        exit 1
    fi

    echo "Updating package list... 🔄"
    sudo apt update

    echo "Restoring packages... 📥"
    sudo dpkg --set-selections < "$BACKUP_FILE"
    sudo apt-get -y dselect-upgrade

    echo "Packages restored successfully! 🎉"
}

# Main script logic
case "$1" in
    backup)
        backup_packages
        ;;
    restore)
        restore_packages
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
        ;;
esac
