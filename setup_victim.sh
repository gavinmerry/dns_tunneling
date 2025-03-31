#!/bin/bash

echo "[*] Setting up Victim VM..."

# Prompt for Forwarder IP
read -p "Enter the IP address of the DNS Forwarder: " FORWARDER_IP

# Install pipx if not already installed
if ! command -v pipx &> /dev/null; then
    echo "[*] pipx not found. Installing pipx..."
    sudo apt update
    sudo apt install -y python3-pip
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "[+] pipx is already installed."
fi

# Install dnspython via pipx
pipx install dnspython || pipx reinstall dnspython

# Set DNS to point to forwarder
sudo sed -i "s/^#*DNS=.*/DNS=${FORWARDER_IP}/" /etc/systemd/resolved.conf
sudo sed -i "s/^#*FallbackDNS=.*/FallbackDNS=/" /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

echo "[+] Victim setup complete. DNS set to forwarder at ${FORWARDER_IP}."
