#!/bin/bash -eu

cd /etc/nixos
git pull
nixos-rebuild switch
