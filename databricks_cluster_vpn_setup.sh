#!/bin/bash

# Update package manager and install OpenVPN
sudo yum update -y
sudo yum install -y openvpn

# Install AWS CLI if not already installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found, installing..."
    sudo yum install -y aws-cli
fi

# Set the region (You can set this in your Terraform variables)
REGION=us-east-1  # Change to your region

# Download OpenVPN configuration and static key from S3
aws s3 cp s3://private-databricks-data-bucket/init-scripts/client.ovpn /home/ec2-user/client.ovpn --region $REGION
aws s3 cp s3://private-databricks-data-bucket/init-scripts/static.key /home/ec2-user/static.key --region $REGION

# Start the OpenVPN connection
sudo openvpn --config /home/ec2-user/client.ovpn --daemon
