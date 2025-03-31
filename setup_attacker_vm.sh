#!/bin/bash

echo "[*] Setting up Attacker DNS Server..."

# Install Python and dnslib
sudo apt update
sudo apt install -y python3-pip
pip3 install dnslib

# Open UDP port 53 in UFW (if installed)
if command -v ufw >/dev/null 2>&1; then
    sudo ufw allow 53/udp
fi

echo "[+] Attacker DNS Server setup complete. Now run your dns_exfil_server.py"
