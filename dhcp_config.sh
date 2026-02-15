#/bin/bash
#This scipt aims to config dhcp server using isc-dhcp-server

#Run as root
if ["$(EUID)" -ne 0];then
	echo "Please run as root"
	exit 1
fi

echo "=== DHCP Server Setup ==="

#Install the server
if ! command -v dhcpd >/dev/null 2>&1; then
	echo "Installing isc-dhcp-server..."
	apt update
	apt install -y isc-dhcp-server
fi
#Network Constants

SUBNET="192.168.44.0"
NETMASK="255.255.255.0"
RANGE_START="192.168.44.100"
RANGE_END="192.168.44.200"
ROUTER="192.168.44.1"
DNS="8.8.8.8"

if [ -f /etc/dhcp/dhcpd.conf ];then
	cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup
fi 

cat > /etc/dhcp/dhcpd.conf <<EOL
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet $SUBNET netmask $NETMASK {
    range $RANGE_START $RANGE_END;
    option routers $ROUTER;
    option domain-name-servers $DNS;
}
EOL

echo "Dhcp configs are written to /etc/dhcp/dhcpd.conf"

systemctl restart isc-dhcp-server
systemctl status isc-dhcp-server|head -n 10
echo "=== DHCP configuration completed ==="
