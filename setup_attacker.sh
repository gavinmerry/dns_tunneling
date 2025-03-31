#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run this script with sudo"
    exit 1
fi

echo "[*] Setting up Attacker DNS Server..."

# Install pipx
if ! command -v pipx &> /dev/null; then
    echo "[*] pipx not found. Installing pipx system-wide..."
    apt update
    apt install -y pipx
fi
export PATH="$PATH:/usr/local/bin:/root/.local/bin"

# Install dnslib using pipx
pipx install dnslib || pipx reinstall dnslib

# Allow UDP port 53 (if firewall is active)
if command -v ufw &> /dev/null; then
    ufw allow 53/udp
fi

echo "[+] Attacker DNS Server setup complete. You can now run dns_exfil_server.py"
