#!/bin/bash

echo "[*] Setting up Attacker DNS Server..."

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

# Install dnslib via pipx
pipx install dnslib || pipx reinstall dnslib

# Open port 53 if using ufw
if command -v ufw &> /dev/null; then
    sudo ufw allow 53/udp
fi

echo "[+] Attacker DNS Server setup complete. Now run your dns_exfil_server.py"
