#!/bin/bash -eu

function __run() {
  cd /etc/nixos
  git pull
  nixos-rebuild switch
}

__run
