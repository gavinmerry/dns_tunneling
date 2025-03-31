#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run this script with sudo"
    exit 1
fi

echo "[*] Setting up Attacker DNS Server..."

# Install Python and venv
apt update
apt install -y python3 python3-venv

# Create virtual environment
mkdir -p venv
python3 -m venv venv

# Activate venv and install dnslib
source venv/bin/activate
pip install --upgrade pip
pip install dnslib

# Open port 53 if UFW is enabled
if command -v ufw &> /dev/null; then
    ufw allow 53/udp
fi

echo "[+] Attacker DNS Server setup complete. Virtual environment created at venv"
echo "[*] To activate it: source venv/bin/activate"
