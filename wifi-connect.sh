#!/bin/bash

# This script uses NetworkManager to connect to a specified Wi-Fi network on the wlan0 interface.
# The Wi-Fi remains connected until the device is rebooted.

# Check if the required arguments are passed
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 --essid ESSID -p PASSWORD"
    exit 1
fi

# Extract ESSID and PASSWORD from the command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --essid) essid="$2"; shift ;;
        -p) password="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if ESSID and PASSWORD have been assigned
if [ -z "$essid" ] || [ -z "$password" ]; then
    echo "Both ESSID and password are required."
    exit 1
fi

# Generate a unique connection name
conn_name="wifi-$(date +%s)"

# Create a new Wi-Fi connection specifically for wlan0
nmcli con add type wifi ifname 'wlan0' con-name "$conn_name" ssid "$essid"

# Set the Wi-Fi security and password
nmcli con modify "$conn_name" wifi-sec.key-mgmt wpa-psk
nmcli con modify "$conn_name" wifi-sec.psk "$password"

# Enable the connection
nmcli con up id "$conn_name"

# Output the connection status
echo "Connected to $essid on wlan0 with connection name $conn_name. This connection will persist until reboot."
