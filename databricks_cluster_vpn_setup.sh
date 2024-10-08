#!/bin/bash

# Define the region and local directory path for the VPN configuration
#LOCAL_VOLUME="/Users/ayushpandey/work/projects/private-databricks/isolake"
LOCAL_VOLUME="/Volumes/main/test/test_volume"
LOG_FILE="$LOCAL_VOLUME/vpn_setup.log"

# Update package manager and install OpenVPN
echo "Installing OpenVPN" >> $LOG_FILE
sudo yum update -y >> $LOG_FILE 2>&1
sudo yum install -y openvpn >> $LOG_FILE 2>&1
echo "OpenVPN installed successfully" >> $LOG_FILE

# Start the OpenVPN connection
sudo openvpn --config $LOCAL_VOLUME/client.ovpn --daemon >> $LOG_FILE 2>&1
echo "OpenVPN started successfully" >> $LOG_FILE