#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run this script with sudo"
    exit 1
fi

echo "[*] Setting up Victim VM..."
read -p "Enter the IP address of the DNS Forwarder: " FORWARDER_IP

# Install pipx
if ! command -v pipx &> /dev/null; then
    echo "[*] pipx not found. Installing pipx system-wide..."
    apt update
    apt install -y pipx
fi
export PATH="$PATH:/usr/local/bin:/root/.local/bin"

# Install dnspython using pipx
pipx install dnspython || pipx reinstall dnspython

# Set DNS to point to forwarder
sed -i "s/^#*DNS=.*/DNS=${FORWARDER_IP}/" /etc/systemd/resolved.conf
sed -i "s/^#*FallbackDNS=.*/FallbackDNS=/" /etc/systemd/resolved.conf
systemctl restart systemd-resolved

echo "[+] Victim setup complete. DNS set to forwarder at ${FORWARDER_IP}."
