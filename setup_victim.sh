#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run this script with sudo"
    exit 1
fi

echo "[*] Setting up Victim VM..."
read -p "Enter the IP address of the DNS Forwarder: " FORWARDER_IP

# Install Python and venv
apt update
apt install -y python3 python3-venv

# Create venv for the DNS client
mkdir -p venv
python3 -m venv venv

# Activate venv and install dnspython
source venv/bin/activate
pip install --upgrade pip
pip install dnspython

# Set DNS to use the forwarder
sed -i "s/^#*DNS=.*/DNS=${FORWARDER_IP}/" /etc/systemd/resolved.conf
sed -i "s/^#*FallbackDNS=.*/FallbackDNS=/" /etc/systemd/resolved.conf
systemctl restart systemd-resolved

echo "[+] Victim setup complete. Virtual environment created at venv"
echo "[*] To activate it: source venv/bin/activate"
