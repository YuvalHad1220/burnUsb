#!/bin/bash

# Function to list connected USB drives
list_usb_drives() {
    echo "USB drives connected:"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -i "disk"
}

# Function to select ISO file
select_iso_file() {
    echo "Please provide the path to the ISO file you want to burn:"
    read -e iso_path
    if [ ! -f "$iso_path" ]; then
        echo "Error: File not found. Please provide a valid path to the ISO file."
        select_iso_file
    fi
}

# Function to select USB drive
select_usb_drive() {
    echo "Please enter the name of the USB drive you want to use (e.g., sdb):"
    read -e usb_drive_name
    usb_drive="/dev/$usb_drive_name"
    if [ ! -b "$usb_drive" ]; then
        echo "Error: Not a valid block device. Please enter a valid USB drive name."
        select_usb_drive
    fi
}

# Function to burn ISO to USB drive
burn_iso_to_usb() {
    echo "Burning ISO to USB drive..."
    sudo dd bs=4M if="$iso_path" of="$usb_drive" status=progress
    echo "ISO burned successfully to $usb_drive."
}

# Main script starts here
echo "Welcome! This script will help you burn an ISO file to a USB drive."

# List connected USB drives
list_usb_drives

# Select ISO file
select_iso_file

# Select USB drive
select_usb_drive

# Confirm selection
echo "You have selected:"
echo "ISO file: $iso_path"
echo "USB drive: $usb_drive"
echo "Is this correct? (y/n)"
read confirm
if [ "$confirm" != "y" ]; then
    echo "Operation canceled."
    exit 1
fi

# Burn ISO to USB drive
burn_iso_to_usb
