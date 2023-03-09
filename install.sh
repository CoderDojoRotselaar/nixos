#!/bin/bash

fdisk /dev/vda <<EO_PT
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

wipefs -af /dev/vda1
mkfs.fat -F 32 /dev/vda1
fatlabel /dev/vda1 boot

wipefs -af /dev/vda2
pvcreate -ff /dev/vda2
vgcreate rootvg /dev/vda2

lvcreate -y -L 20G -n root rootvg
wipefs -af /dev/rootvg/root
mkfs.ext4 /dev/rootvg/root -L root

lvcreate -y -L 4G -n swap rootvg
wipefs -af /dev/rootvg/swap
mkswap /dev/rootvg/swap

mount /dev/disk/by-label/root /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
