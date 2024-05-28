#!/bin/bash

# Initialize and apply Terraform configuration
terraform init
terraform apply -auto-approve

# Get the public IP address of the instance
instance_ip=$(terraform output -raw instance_public_ip)

# Print the IP address to a file
echo "The public IP address of the instance is: $instance_ip" > instance_ip.txt

# Display the content of the file
cat instance_ip.txt