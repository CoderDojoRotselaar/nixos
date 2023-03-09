#!/bin/bash

sfdisk --force /dev/vda <<EO_PT
label: dos
label-id: 0xf5c8b889
device: /dev/vda
unit: sectors
sector-size: 512

/dev/vda1 : start =        2048, size =      1024000, type=83
/dev/vda2 : start =     1026048, size =    103831552, type=8e

EO_PT

wipefs -a /dev/vda1

mkfs.fat -F 32 /dev/vda1
fatlabel /dev/vda1 boot

wipefs -a /dev/vda2
pvcreate /dev/vda2
vgcreate rootvg /dev/vda2

lvcreate -L 20G -n root rootvg
mkfs.ext4 /dev/rootvg/root -L root

lvcreate -L 4G -n swap rootvg
mkswap /dev/rootvg/swap

mount /dev/disk/by-label/root /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
