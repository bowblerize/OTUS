#!/bin/bash

NEW_DISK=$1
VG=$2
LV=$3

pvcreate $NEW_DISK
vgcreate $VG $NEW_DISK
lvcreate -y -n $LV -l +100%FREE /dev/$VG

mkfs.ext4 -F /dev/$VG/$LV

mkdir -p /mnt/$VG

mount /dev/$VG/$LV /mnt/$VG

rsync -avxHA --progress / /mnt/$VG


for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$VG/$i; done

chroot /mnt/$VG /bin/bash <<EOF

grub-mkconfig -o /boot/grub/grub.cfg

update-initramfs -u

EOF

init 6
