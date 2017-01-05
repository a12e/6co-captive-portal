#!/bin/bash

# Configure un ordinateur en tant que passerelle, avec un serveur DHCP dessus
# usage: ./setup-gateway.sh <Internet-facing interface> <Raspberry Pi interface>


if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
fi

INET_IFACE=$1
PI_IFACE=$2

echo "Stopping NetworkManager..."
sudo service network-manager status && sudo service network-manager stop

echo "Stop bind9 daemon..."
sudo service bind9 status && sudo service bind9 stop

# Stop on first error
set -e

echo "Flushing iptable filter..."
iptables -t filter -F

echo "Flushing iptable nat..."
iptables -t nat -F

echo "Flushing iptable mangle..."
iptables -t mangle -F

echo "Getting IP address on $INET_IFACE..."
dhclient -v $INET_IFACE

echo "Enabling IP forward..."
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

echo "Configuring the Raspberry Pi interface $PI_IFACE..."
ip addr add 192.168.1.254/24 dev $PI_IFACE
ip link set $PI_IFACE up

echo "Adding MASQUERADE rule"
sudo iptables -t nat -A POSTROUTING -o $INET_IFACE -j MASQUERADE

echo "Starting DHCP+DNS forwarding server on $PI_IFACE..."
dnsmasq -kdq --dhcp-range=192.168.1.1,192.168.1.250 --dhcp-host=b8:27:eb:61:32:6b,192.168.1.1 --server=130.79.200.200 --interface=$PI_IFACE
