
#in /boot/firmware/cmdline.txt
#append
#systemd.unified_cgroup_hierarchy=1 cgroup_enable=memory cgroup_memory=1

echo $(cat /boot/firmware/cmdline.txt) csystemd.unified_cgroup_hierarchy=1 cgroup_enable=memory cgroup_memory=1  | sudo tee /boot/firmware/cmdline.txt

sudo reboot
cat /sys/fs/cgroup/cgroup.controllers

#fix dns server
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf

#Failed to find memory cgroup, you may need to add "cgroup_memory=1 cgroup_enable=memory" to your linux cmdline (/boot/firmware/cmdline.txt on a Raspberry Pi)
#[INFO]  systemd: Enabling k3s-agent unit
#    sudo systemctl status k3s-agent.services