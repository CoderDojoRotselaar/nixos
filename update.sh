#!/usr/bin/env bash

set -eu

function __run() {
  cd /etc/nixos
  git reset --hard HEAD
  git restore .
  git pull
  nixos-rebuild switch
  nix-collect-garbage --delete-older-than 14d
}

__run
