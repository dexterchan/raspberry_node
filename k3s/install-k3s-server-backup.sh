#!/bin/bash

# Install K3s on secondary server
K3S_VERSION=v1.34.1+k3s1
SECRET=$(cat /media/boot/k3s_secret_token)
PRIMARY_IP_ADDRESS="192.168.50.172"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" \
     K3S_TOKEN=${SECRET} sh -s - server \
     --disable=traefik \
    --server https://${PRIMARY_IP_ADDRESS}:6443 

k3s_grp=k3s
sudo groupadd --system   ${k3s_grp}
sudo usermod -a -G ${k3s_grp} odroid

sudo usermod -a -G ${k3s_grp} droid
sudo chgrp ${k3s_grp} /etc/rancher/k3s/k3s.yaml
sudo chmod 660 /etc/rancher/k3s/k3s.yaml
echo export KUBECONFIG=/etc/rancher/k3s/k3s.yaml >> ~/.bashrc
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Verify installation
kubectl get nodes

kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule


echo uninstall with '/usr/local/bin/k3s-uninstall.sh'