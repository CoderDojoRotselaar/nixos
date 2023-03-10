#!/usr/bin/env bash

set -eu

MAIN_DISK=$(find /dev/ -maxdepth 1 -name '?da' -print -quit)
WIFI_DEVICE=$(find /run/wpa_supplicant/ -name 'wlp*' -print -quit)

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

  wpa_cli -g "${WIFI_DEVICE}" remove_network 0 &>/dev/null
  wpa_cli -g "${WIFI_DEVICE}" add_network
  wpa_cli -g "${WIFI_DEVICE}" set_network 0 ssid "\"${WIFI_SSID}\""

  read -s -p "Please enter your WIFI password: " -r WIFI_PASSWORD
  wpa_cli -g "${WIFI_DEVICE}" set_network 0 psk "\"${WIFI_PASSWORD}\""

  wpa_cli -g "${WIFI_DEVICE}" enable_network 0

  _network 30
}

function _format() {
  echo "o n p 1 2048 +500M n p 2   t 2 lvm w" | tr ' ' "\n" | fdisk "${MAIN_DISK}"

  wipefs -af "${MAIN_DISK}"1
  mkfs.fat -F 32 "${MAIN_DISK}"1
  fatlabel "${MAIN_DISK}"1 boot

  wipefs -af "${MAIN_DISK}"2
  pvcreate -ff "${MAIN_DISK}"2
  vgcreate rootvg "${MAIN_DISK}"2

  lvcreate -y -L 20G -n root rootvg
  wipefs -af /dev/rootvg/root
  mkfs.ext4 /dev/rootvg/root -L root

  lvcreate -y -L 4G -n swap rootvg
  wipefs -af /dev/rootvg/swap
  mkswap /dev/rootvg/swap

}

function _mount() {
  mount /dev/rootvg/root /mnt
  mkdir -p /mnt/boot
  swapon /dev/rootvg/swap
  mount "${MAIN_DISK}"1 /mnt/boot
}

function _clone() {
  mkdir -p /mnt/etc/
  git clone https://github.com/CoderDojoRotselaar/nixos/ /mnt/etc/nixos/

  cd /mnt/etc/nixos

  DISK_NAME=$(basename "${MAIN_DISK}")
  ln -s disk.nix "disk_${DISK_NAME}.nix"
}

function _generate_config() {
  nixos-generate-config --root /mnt
}

function _install() {
  cd /mnt
  nixos-install --no-root-passwd
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
