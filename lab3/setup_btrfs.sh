#!/bin/bash

DISK=$1
MOUNT_TARGET="/opt"
TEMP_MOUNT="/mnt/btrfs_tmp"

apt update

apt install -y btrfs-progs

modprobe btrfs

mkfs.btrfs -f $DISK


mkdir -p $TEMP_MOUNT
mount $DISK $TEMP_MOUNT

btrfs subvolume create $TEMP_MOUNT/@opt
btrfs subvolume create $TEMP_MOUNT/@snapshots

rsync -avxHA --progress /opt/ $TEMP_MOUNT/@opt
umount $TEMP_MOUNT

UUID=$(blkid -s UUID -o value $DISK)


FSTAB_ENTRY="UUID=$UUID  $MOUNT_TARGET  btrfs  defaults,noatime,space_cache=v2,compress=zstd,subvol=@opt  0  0"


echo "$FSTAB_ENTRY" >> /etc/fstab

systemctl daemon-reload

mount -a
