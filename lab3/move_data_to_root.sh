#!/bin/bash

read -r LV VG <<< $(lvm lvs | awk 'NR==2 {print $1, $2}' )

lvremove -y /dev/$VG/$LV
lvcreate -y -n $LV -L 8G /dev/$VG
mkfs.ext4 /dev/$VG/$LV

mkdir -p /mnt/$VG
mount /dev/$VG/$LV /mnt/$VG
rsync -avxHA --progress / /mnt/$VG
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$VG/$i; done
chroot /mnt/$VG /bin/bash << EOF

grub-mkconfig -o /boot/grub/grub.cfg
update-initramfs -u
cd /tmp

touch /home/file{1..20}

lvcreate -n lv_home -L 1G $VG
mkfs.ext4 /dev/$VG/lv_home
mkdir -p /mnt/home
mount /dev/$VG/lv_home /mnt/home
rsync -avxHA --progress /home/ /mnt/home

lvcreate -L 50M -s -n snap_home /dev/$VG/lv_home

pvcreate /dev/vdc /dev/vdd
vgcreate vg_var /dev/vdc /dev/vdd
lvcreate -L 800M -m1 -n lv_var vg_var 
mkfs.ext4 /dev/vg_var/lv_var
mkdir -p /mnt/var
mount /dev/vg_var/lv_var /mnt/var
rsync -avxHA --progress /var/ /mnt/var

echo "/dev/vg_var/lv_var  /var  ext4  defaults  0 2" >> /etc/fstab
echo "/dev/$VG/lv_home  /home  ext4  defaults  0 0" >> /etc/fstab

exit
EOF

init 6
