#!/usr/bin/env bash

set -eu

function __run() {
  cd /etc/nixos
  git pull
  nixos-rebuild switch
}

__run
