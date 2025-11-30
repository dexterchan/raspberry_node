#!/bin/sh
username=$1
pwd=$2
sudo mkdir -p /mnt/download
cp /etc/fstab /tmp/fstab
echo "//192.168.50.1/Downloads  /mnt/download cifs iocharset=utf8,rw,vers=1.0,user=$username,pass=$pwd,uid=1000,gid=1000 0 0">> /tmp/fstab
sudo cp /tmp/fstab /etc/fstab
sudo mount -a