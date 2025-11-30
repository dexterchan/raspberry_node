#!/bin/sh
# reference: https://github.com/k3s-io/k3s/releases
#unblock the ports in firewall
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 6443
# sudo ufw allow from 192.168.1.0/24 proto udp to any port 8472
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 10250
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 2379:2380


sudo apt-get install -y curl
sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm



SECRET=$(date +%s | sha256sum | base64 | head -c 32 )
echo off
echo $SECRET | sudo tee /boot/k3s_secret_token
SECRET=$(cat /boot/k3s_secret_token)
K3S_VERSION=v1.34.1+k3s1
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" K3S_KUBECONFIG_MODE="644"  sh -s - server --disable=traefik \
  --token=$SECRET  \
  -cluster-init 
  #--datastore-endpoint="${conn_str}"
sudo mv  /var/lib/rancher/k3s/server/manifests/traefik.yaml /var/lib/rancher/k3s/server/manifests/traefik.yaml.skip
echo on


# Reference from https://rancher.com/docs/k3s/latest/en/quick-start/
# curl -sfL https://get.k3s.io | sh -
# Check for Ready node,
#takes maybe 30 seconds
sleep 30
k3s kubectl get node
#
#[INFO]  Failed to find memory cgroup, you may need to add "cgroup_memory=1 cgroup_enable=memory" to your linux cmdline (/boot/cmdline.txt on a Raspberry Pi)
#[INFO]  systemd: Enabling k3s unit

k3s_grp=k3s
sudo groupadd --system   ${k3s_grp}
sudo usermod -a -G ${k3s_grp} pi

sudo chgrp ${k3s_grp} /etc/rancher/k3s/k3s.yaml
sudo chmod 660 /etc/rancher/k3s/k3s.yaml
#Without this, you got Error: Kubernetes cluster unreachable
echo export KUBECONFIG=/etc/rancher/k3s/k3s.yaml >> ~/.bashrc
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
#SMB driver for k3s
#https://github.com/kubernetes-csi/csi-driver-smb/tree/master/charts
#helm repo add csi-driver-smb https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts
#helm install csi-driver-smb csi-driver-smb/csi-driver-smb --namespace kube-system --version v1.5.0
#example
#https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md
echo uninstall with '/usr/local/bin/k3s-uninstall.sh'


  
# opening port for ingress
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 80
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 443

kubectl label nodes $(hostname) type=driver

#An example NGINX Ingress that makes use of the controller:
#   apiVersion: networking.k8s.io/v1
#   kind: Ingress
#   metadata:
#     name: example
#     namespace: foo
#   spec:
#     ingressClassName: nginx
#     rules:
#       - host: www.example.com
#         http:
#           paths:
#             - pathType: Prefix
#               backend:
#                 service:
#                   name: exampleService
#                   port:
#                     number: 80
#               path: /
#     # This section is only required if TLS is to be enabled for the Ingress
#     tls:
#       - hosts:
#         - www.example.com
#         secretName: example-tls

# If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

#   apiVersion: v1
#   kind: Secret
#   metadata:
#     name: example-tls
#     namespace: foo
#   data:
#     tls.crt: <base64 encoded cert>
#     tls.key: <base64 encoded key>
#   type: kubernetes.io/tls

# # Turn on the calico
# # # as of 3NOV22, calico exhausted memory resource to 1.5GB in each node. It left little memory to run actual job.
# # # ref: https://projectcalico.docs.tigera.io/getting-started/kubernetes/flannel/flannel#installing-with-the-kubernetes-api-datastore-recommended
# wget -O /tmp/canal_org.yaml https://docs.projectcalico.org/manifests/canal.yaml 
# # #Seem having problem with below POD_CIDR
# # #POD_CIDR=$(kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}')
# POD_CIDR="172.16.0.0/16"
# sed \
# -e 's|            # - name: CALICO_IPV4POOL_CIDR|            - name: CALICO_IPV4POOL_CIDR|g' \
# -e 's|            #   value: \"192.168.0.0/16\"|              value: \"'${POD_CIDR}'\"|g' /tmp/canal_org.yaml > /tmp/canal.yaml 
# kubectl apply -f /tmp/canal.yaml

# nginx controller replacement
# https://kubernetes.github.io/ingress-nginx/deploy/
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule
