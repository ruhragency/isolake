#!/bin/bash

# Define the region and local directory path for the VPN configuration
#LOCAL_VOLUME="/Users/ayushpandey/work/projects/private-databricks/isolake"
LOCAL_VOLUME="/Volumes/main/test/test_volume"
LOG_FILE="$LOCAL_VOLUME/vpn_setup.log"

echo $PWD >> $LOG_FILE

# Update package manager and install OpenVPN
#echo "Installing OpenVPN" >> $LOG_FILE
#if ! sudo apt-get update >> $LOG_FILE 2>&1; then
#    echo "apt-get update failed" >> $LOG_FILE
#    exit 1
#fi

if ! sudo apt-get install -y openvpn >> $LOG_FILE 2>&1; then
    echo "OpenVPN installation failed" >> $LOG_FILE
    exit 1
fi
echo "OpenVPN installed successfully" >> $LOG_FILE

# Start the OpenVPN connection
if ! sudo openvpn --config $LOCAL_VOLUME/client.ovpn --daemon >> $LOG_FILE 2>&1; then
    echo "OpenVPN failed to start" >> $LOG_FILE
    exit 1
fi
echo "OpenVPN started successfully" >> $LOG_FILE