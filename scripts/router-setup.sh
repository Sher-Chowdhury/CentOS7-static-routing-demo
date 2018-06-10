#!/usr/bin/env bash
exit 0
set -ex

echo '##########################################################################'
echo '#################### About to run router-rpms.sh script ##################'
echo '##########################################################################'


echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

sysctl --system

firewall-cmd --permanent --add-masquerade
systemctl restart firewalld

exit 0