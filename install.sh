#!/usr/bin/env bash

set -eu

MAIN_DISK=$(find /dev/ -maxdepth 1 -name '?da' -print -quit)
WIFI_DEVICE=$(find /run/wpa_supplicant/ -name 'wlp*' -print -quit)
DISK_NAME=$(basename "${MAIN_DISK}")
SYSTEM_UUID=$(dmidecode -s system-uuid)

function _verify_disk() {
  if [[ -n "${MAIN_DISK}" ]]; then
    echo "We can install to '${MAIN_DISK}'."
    return
  fi

  echo "No disk found to install on."
  false
}

function _test_live() {
  ip ro get 8.8.8.8 &>/dev/null
}

function _test_network() {
  DELAY=${1:-30}
  echo -n "Waiting for network: "

  while [[ "${DELAY}" -gt 0 ]]; do
    if _test_live; then
      echo
      echo "Network is live!"
      return 0
    fi

    echo -n "${DELAY} "
    DELAY=$((DELAY - 1))
    sleep 1
  done

  echo
  return 1
}

function _network() {
  DELAY=${1:-30}

  if _test_network "${DELAY}"; then
    echo "We have network - let's continue."
    return
  else
    echo "No network - we can connect to WIFI."
  fi

  _connect_wifi
}

function _connect_wifi() {
  if [[ -z "${WIFI_DEVICE}" ]]; then
    echo "No WIFI device detected. We can't continue."
    return 1
  fi

  wpa_cli -g "${WIFI_DEVICE}" scan
  echo "Scanning for available networks..."
  sleep 5
  wpa_cli -g "${WIFI_DEVICE}" scan_results

  read -p "Please enter your WIFI SSID (leave enter to skip): " -r WIFI_SSID

  if [[ -z "${WIFI_SSID}" ]]; then
    return
  fi

  read -s -p "Please enter your WIFI password: " -r WIFI_PASSWORD

  _create_network "${WIFI_SSID}" "${WIFI_PASSWORD}"
}

function _create_network() {
  if [[ -z "${WIFI_DEVICE}" ]]; then
    return
  fi

  if [[ -z "${WIFI_SSID}" ]]; then
    return
  fi

  wpa_cli -g "${WIFI_DEVICE}" remove_network 0 &>/dev/null
  wpa_cli -g "${WIFI_DEVICE}" add_network
  wpa_cli -g "${WIFI_DEVICE}" set_network 0 ssid "\"${WIFI_SSID}\""

  wpa_cli -g "${WIFI_DEVICE}" set_network 0 psk "\"${WIFI_PASSWORD}\""

  wpa_cli -g "${WIFI_DEVICE}" enable_network 0

  _test_network 30
}

function _format() {
  vgchange -an

  echo "o n p 1 2048 +500M n p 2   t 2 lvm w" | tr ' ' "\n" | fdisk "${MAIN_DISK}"

  wipefs -af "${MAIN_DISK}"1
  mkfs.fat -F 32 "${MAIN_DISK}"1
  fatlabel "${MAIN_DISK}"1 boot

  wipefs -af "${MAIN_DISK}"2
  pvcreate -ff "${MAIN_DISK}"2
  vgcreate rootvg "${MAIN_DISK}"2

  lvcreate -y -L 15G -n root rootvg
  wipefs -af /dev/rootvg/root
  mkfs.ext4 /dev/rootvg/root -L root

  lvcreate -y -L 10G -n var rootvg
  wipefs -af /dev/rootvg/var
  mkfs.ext4 /dev/rootvg/var -L var

  lvcreate -y -L 10G -n home rootvg
  wipefs -af /dev/rootvg/home
  mkfs.ext4 /dev/rootvg/home -L home

  lvcreate -y -L 4G -n swap rootvg
  wipefs -af /dev/rootvg/swap
  mkswap /dev/rootvg/swap
}

function _mount() {
  mount /dev/rootvg/root /mnt
  mkdir -p /mnt/{boot,var,home}

  mount "${MAIN_DISK}"1 /mnt/boot
  mount /dev/rootvg/var /mnt/var
  mount /dev/rootvg/home /mnt/home

  swapon /dev/rootvg/swap
}

function _clone() {
  mkdir -p /mnt/etc/
  git clone https://github.com/CoderDojoRotselaar/nixos/ /mnt/etc/nixos/

  cd /mnt/etc/nixos

  ln -s "disk_${DISK_NAME}.nix" disk.nix

  if [[ -f "systems/${SYSTEM_UUID}.nix" ]]; then
    ln -s "systems/${SYSTEM_UUID}.nix" system.nix
  else
    ln -s "systems/default.nix" system.nix
  fi
}

function _generate_config() {
  nixos-generate-config --root /mnt
}

function _install() {
  cd /mnt
  nixos-install --no-root-passwd --flake "https://github.com/CoderDojoRotselaar/nixos#${SYSTEM_UUID}" --impure
}

[[ -f /etc/include.secrets.sh ]] && source /etc/include.secrets.sh

_verify_disk

echo "Trying to install!"
echo "Press enter to continue... or ctrl+c to stop"
read -r _CONTINUE

_run_before_network
_network 5

set -x
_format
_mount
_clone
_generate_config
_run_before_install
_install
_run_after_install

echo "Remove the installation medium and press enter reboot now... or ctrl+c to stop"
read -r _REBOOT
reboot
