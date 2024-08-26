#!/bin/bash

# Function to update the pivpnHOST in the setupVars.conf file
update_pivpn_host() {
    local config_file="$1"
    local new_host="$2"
    # Concatenate ".duckdns.org" to the new_host
    local updated_host="${new_host}.duckdns.org"

    # Use sed to replace the pivpnHOST value
    sudo sed -i "s/^pivpnHOST=.*/pivpnHOST=${updated_host}/" "$config_file"
}

# Function to update TOKEN and SUBDOMAINS in the docker-compose.yml file
update_duckdns_config() {
    local compose_file="$1"
    local new_token="$2"
    local new_subdomains="$3"

    # Use sed to replace the TOKEN and SUBDOMAINS values
    sudo sed -i "s/^\(\s*- TOKEN=\).*/\1${new_token}/" "$compose_file"
    sudo sed -i "s/^\(\s*- SUBDOMAINS=\).*/\1${new_subdomains}/" "$compose_file"
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <new_pivpn_host> <new_token> <new_subdomains>"
    exit 1
fi

# Assign the arguments to variables
NEW_HOST_SUBDOMAINS="$1"
NEW_TOKEN="$2"
NEW_SUBDOMAINS="$3"

# Path to the configuration file
CONFIG_FILE="/etc/pivpn/wireguard/setupVars.conf"

# Update the configuration file with the new pivpnHOST value
echo "Modifying PiVPN DNS configuration..."
update_pivpn_host "$CONFIG_FILE" "$NEW_HOST_SUBDOMAINS"

# Check if the first step was successful
if [ $? -eq 0 ]; then
    echo "PiVPN DNS configuration modified successfully."
else
    echo "Failed to modify PiVPN DNS configuration."
    exit 1
fi

# Path to the Docker Compose file
DOCKER_COMPOSE_FILE="/docker/duckdns/docker-compose.yml"

# Update the Docker Compose file with the new TOKEN and SUBDOMAINS values
echo "Modifying DuckDNS Docker Compose file..."
update_duckdns_config "$DOCKER_COMPOSE_FILE" "$NEW_TOKEN" "$NEW_HOST_SUBDOMAINS"

# Check if the second step was successful
if [ $? -eq 0 ]; then
    echo "DuckDNS Docker Compose file modified successfully."
else
    echo "Failed to modify DuckDNS Docker Compose file."
    exit 1
fi

# Bring up the Docker containers
echo "Bringing up DuckDNS Docker containers..."
cd /docker/duckdns
sudo docker-compose up -d

if [ $? -eq 0 ]; then
    echo "DuckDNS Docker containers are up and running."
else
    echo "Failed to bring up DuckDNS Docker containers."
    exit 1
fi

echo "Script completed successfully. Rebooting the system..."

# Reboot the system
sudo reboot
