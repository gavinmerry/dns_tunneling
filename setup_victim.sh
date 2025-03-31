#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run this script with sudo"
    exit 1
fi

echo "[*] Setting up Victim VM..."

# Prompt for DNS Forwarder IP
read -p "Enter the IP address of the DNS Forwarder: " FORWARDER_IP

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

# Install dnspython via pipx
pipx install dnspython || pipx reinstall dnspython

# Set DNS to forwarder
sed -i "s/^#*DNS=.*/DNS=${FORWARDER_IP}/" /etc/systemd/resolved.conf
sed -i "s/^#*FallbackDNS=.*/FallbackDNS=/" /etc/systemd/resolved.conf
systemctl restart systemd-resolved

echo "[+] Victim setup complete. DNS set to forwarder at ${FORWARDER_IP}."
