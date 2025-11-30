#!/bin/sh
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 6443
# sudo ufw allow from 192.168.1.0/24 proto udp to any port 8472
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 10250
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 2379:2380


# install k3s service
echo install k3s service
# curl -sfL https://get.k3s.io | sh -
server=$1
logfile=/var/log/k3_agent.log

echo "Enter the k3s token: "  
read SECRET
echo "Got secret: ${SECRET}"

echo "Enter the master server ipaddress: "
read server_ipaddress
echo "Got master server: ${server_ipaddress}"

# curl -sfL https://get.k3s.io | K3S_URL=https://${server_ipaddress}:6443 \
#                                K3S_TOKEN=$SECRET sh -

#if [ -z "$server" ]; then
server_agent="agent"
taint_condition="--node-taint run:NoSchedule"
# else
#     server_agent="server"
#     taint_condition="--node-taint node-role.kubernetes.io/control-plane:NoSchedule"
# fi

K3S_VERSION=v1.34.1+k3s1
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" sh -s - ${server_agent} \
                                --token $SECRET \
                                --server https://${server_ipaddress}:6443 \
                                --log /var/log/k3_runtime.log \
                                ${taint_condition} 
                                #--node-label type=compute 
                                #--node-taint workload=high:NoSchedule

echo uninstall with '/usr/local/bin/k3s-agent-uninstall.sh'

node_name=$(cat /etc/hostname)
# echo kubectl label nodes ${node_name} type=compute