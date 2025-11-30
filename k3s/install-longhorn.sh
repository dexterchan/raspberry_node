#!/bin/bash
echo on each machine
echo sudo apt update && sudo apt install open-iscsi -y
echo sudo apt-get install nfs-common -y

kubectl label nodes rasp-node1 rasp-node2 rasp-node3 storage=longhorn

helm repo add longhorn https://charts.longhorn.io
helm repo update

helm install longhorn longhorn/longhorn -n longhorn-system --create-namespace --values long-horn-storage-values.yaml

kubectl apply -f long-horn-ingress.yaml