#!/bin/bash

# Define the region and local directory path for the VPN configuration
LOCAL_VOLUME="/Volumes/main/test/test_volume"
LOG_FILE="/Volumes/main/test/test_volume/vpn_setup.log"

# Ping Google to check internet connectivity
echo "Pinging Google to check connectivity..." >> $LOG_FILE
ping -c 1 google.com >> $LOG_FILE
if [ $? -ne 0 ]; then
    echo "Ping failed. No internet connectivity." >> $LOG_FILE
    exit 1
else
    echo "Ping successful." >> $LOG_FILE
fi

# Update package manager and install OpenVPN
echo "Installing OpenVPN" >> $LOG_FILE
sudo yum update -y
sudo yum install -y openvpn
echo "OpenVPN installed successfully" >> $LOG_FILE



# Copy OpenVPN configuration and static key from the local volume
echo "Copying OpenVPN configuration from the local volume" >> $LOG_FILE
cp $LOCAL_VOLUME/client.ovpn /home/ec2-user/client.ovpn
cp $LOCAL_VOLUME/static.key /home/ec2-user/static.key
echo "Successfully copied VPN configuration from the local volume" >> $LOG_FILE

# Start the OpenVPN connection
sudo openvpn --config /home/ec2-user/client.ovpn --daemon
echo "OpenVPN started successfully" >> $LOG_FILE