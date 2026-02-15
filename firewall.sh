#bin/bash
#Clear everything
iptables -F
iptables -X

#Default

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#Allow ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
echo "Firewall rules applied"
