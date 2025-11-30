#!/bin/sh
#cp ~/.ssh/wpa_supplicant.conf /Volumes/bootfs
cp ~/.ssh/surfshark.credential  /Volumes/bootfs
echo cgroup_memory=1 cgroup_enable=memory $(cat /Volumes/bootfs/cmdline.txt ) > /Volumes/bootfs/cmdline.txt
#touch /Volumes/bootfs/ssh
cp 1_soup-base.setup.sh /Volumes/bootfs
cp 1_soup-base.setup_no_docker.sh /Volumes/bootfs
cp 1_soup-base.setup_simple.sh /Volumes/bootfs
cp install-ssmagent.sh /Volumes/bootfs
cp install-wifiap.sh /Volumes/bootfs
cp wifi2g_config.conf /Volumes/bootfs
cp wifi5g_config.conf /Volumes/bootfs
cp wifi5g_config2.conf /Volumes/bootfs
cp install-cifs_client.sh /Volumes/bootfs
cp install-k3s-server.sh /Volumes/bootfs
cp install-k3s-agent.sh /Volumes/bootfs
cp install-torrent.sh /Volumes/bootfs
cp install-microk8s.sh /Volumes/bootfs
cp install-wifi-bridge.sh /Volumes/bootfs
cp install-vpn-client.sh /Volumes/bootfs
cp install-ssmagent.sh /Volumes/bootfs
cp install_swap_drive.sh /Volumes/bootfs
cp ~/.ssh/postgredb.connection_string.sh /Volumes/bootfs
pushd aws_cli_sys_mgr
sh Create_Activation_Code.sh 
cp /tmp/activation.json /Volumes/bootfs
 