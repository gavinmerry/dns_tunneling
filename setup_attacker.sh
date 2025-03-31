#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run this script with sudo"
    exit 1
fi

echo "[*] Setting up Attacker DNS Server..."

# Install pipx if not installed
if ! command -v pipx &> /dev/null; then
    echo "[*] pipx not found. Installing pipx..."
    apt update
    apt install -y python3-pip python3-venv
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    export PATH="$PATH:/root/.local/bin:/home/$SUDO_USER/.local/bin"
else
    echo "[+] pipx is already installed."
fi

# Reload the shell so pipx works
eval "$(/root/.local/bin/pipx completions)"

# Install dnslib via pipx
pipx install dnslib || pipx reinstall dnslib

# Allow UDP port 53 (if ufw is installed)
if command -v ufw &> /dev/null; then
    ufw allow 53/udp
fi

echo "[+] Attacker DNS Server setup complete. You can now run your dns_exfil_server.py"
