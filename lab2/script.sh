#!/bin/bash

echo "Create RAID 5"

DISKS="/dev/vdb /dev/vdc /dev/vdd /dev/vde /dev/vdf"
RAID_DEVICE="/dev/md0"

sudo apt-get update && sudo apt-get install -y mdadm


sudo mdadm --zero-superblock $DISKS


sudo mdadm --create --verbose $RAID_DEVICE --level=5 --raid-devices=5 $DISKS


sudo mkfs.ext4 $RAID_DEVICE



