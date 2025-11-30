#!/bin/bash
host_name=$1

sudo sed -i 's/# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sudo locale-gen

#Then edit  /etc/default/locale 
cat <<EOF > /tmp/locale 
LANG=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
EOF
sudo mv /tmp/locale /etc/default/locale 

if [ -z "$host_name" ]; then
    host_name="ant-node"
fi

echo $host_name | sudo tee /etc/hostname

cat << EOF | sudo tee -a /etc/hosts
127.0.1.1       ${host_name}
EOF

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt install -y avahi-daemon curl open-iscsi
sh ./install_swap_drive.sh
cd /tmp
echo 'alias temp="vcgencmd measure_temp"' >> ~/.bashrc 
#Amend /etc/avahi/avahi-daemon.conf
sudo sed -i 's/#host-name=foo/host-name='${host_name}'/g' /etc/avahi/avahi-daemon.conf

APPUSER=droid
HOMEDIR=/home/${APPUSER}
sudo mkdir -p ${HOMEDIR}
sudo groupadd --system --gid=9999  ${APPUSER} 
sudo chown 9999:9999 /home/${APPUSER}
sudo adduser  --home-dir $HOMEDIR --uid=9999 --gid=${APPUSER} ${APPUSER}
echo "${APPUSER} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo update-alternatives --set iptables  /usr/sbin/iptables-nft
echo "Reboot and allow below commands:"

#sudo ufw allow 22
# echo sudo ufw --force default deny incoming
# echo sudo ufw allow from 192.168.50.0/24 proto tcp to any port 22
# echo sudo ufw --force enable 
