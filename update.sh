#!/usr/bin/env bash -eu

function __run() {
  cd /etc/nixos
  git pull
  nixos-rebuild switch
}

__run
