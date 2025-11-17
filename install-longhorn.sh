#!/bin/bash
sudo apt update && sudo apt install open-iscsi -y


kubectl label nodes rasp-node1 rasp-node2 rasp-node3 storage=longhorn

helm repo add longhorn https://charts.longhorn.io
helm repo update

helm install longhorn longhorn/longhorn -n longhorn-system --create-namespace --values long-horn-storage-values.yaml