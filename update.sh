#!/usr/bin/env bash

set -eu

function _git_reset() {
  cd "$1"
  git reset --hard HEAD
  git restore .
  git pull
}

function __run() {
  _git_reset "/etc/nixos"
  _git_reset "/etc/nixos/secrets"

  nixos-rebuild switch
  nix-collect-garbage --delete-older-than 14d
}

__run
