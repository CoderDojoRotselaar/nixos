#!/bin/bash -e

echo "Trying to install!"
echo "Press enter to continue... or ctrl+c to stop"
read

main_disk=$(find /dev/ -maxdepth 1 -name '?da' -print -quit)

fdisk "${main_disk}" <<EO_PT
o
n
p
1
2048
+500M
n
p
2


t
2
lvm
w
EO_PT

wipefs -af "${main_disk}"1
mkfs.fat -F 32 "${main_disk}"1
fatlabel "${main_disk}"1 boot

wipefs -af "${main_disk}"2
pvcreate -ff "${main_disk}"2
vgcreate rootvg "${main_disk}"2

lvcreate -y -L 20G -n root rootvg
wipefs -af /dev/rootvg/root
mkfs.ext4 /dev/rootvg/root -L root

lvcreate -y -L 4G -n swap rootvg
wipefs -af /dev/rootvg/swap
mkswap /dev/rootvg/swap
swapon /dev/rootvg/swap

mount /dev/rootvg/root /mnt
mkdir -p /mnt/boot
mount "${main_disk}"1 /mnt/boot

mkdir -p /mnt/etc/
git clone https://github.com/CoderDojoRotselaar/nixos/ /mnt/etc/nixos/

nixos-generate-config --root /mnt

cd /mnt
nixos-install

echo "Remove the installation medium and reboot now"
