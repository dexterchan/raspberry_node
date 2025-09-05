
Load the Rasphberry with Raspberry desktop version

Mount the drive
```
sudo rpi-eeprom-update
lsblk

```

if not finding the drive, do following
```
cat << EOF | sudo tee -a /boot/firmware/config.txt
dtparam=nvme
dtparam=pciex1_gen=2
EOF
```
Then, reboot the raspberry

Test I/O speed
```
sudo hdparm -t --direct /dev/nvme0n1
```

Go to 
```
sudo raspi-config
set the reboot sequence to use NVME01
```

sudo rpi-eeprom-update --edit

in the boot.conf file, change the line
BOOT_ORDER=0xf416
PCIE_BOOT=1