#!/bin/bash
echo "[*] Setting up Victim VM..."

# Install Python and dnspython
sudo apt update
sudo apt install -y python3-pip
pip3 install dnspython

# Set DNS to forwarder (replace <FORWARDER_IP>)
sudo sed -i 's/#DNS=.*/DNS=<FORWARDER_IP>/' /etc/systemd/resolved.conf
sudo sed -i 's/#FallbackDNS=.*/FallbackDNS=/' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

echo "[+] Victim setup complete. DNS set to forwarder."
