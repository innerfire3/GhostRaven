#!/bin/bash
sleep 5
# Find the network interface with Ralink chipset
#interface=$(sudo airmon-ng | grep -i 'Ralink' | awk '{print $2}')

# Check if the interface was found
#if [ -z "$interface" ]; then
#    echo "Ralink chipset not found."
#    exit 1
#fi

#echo "Found Ralink chipset on interface: $interface"

# Start airmon-ng on the found interface
/usr/sbin/airmon-ng start wlan1
# Add additional commands if needed
nmcli device set wlan1 managed no &>/dev/null
#echo $interface
sleep 5
/usr/local/bin/bettercap -iface wlan0 -caplet http-ui --eval "events.ignore gps.new; events.ignore wifi.client.new; ble.recon on; set gps.device /dev/ttyACM0; set gps.boundrate 9600; gps on; hid.recon on; set wifi.interface wlan1mon; wifi.recon on" &>/dev/null
