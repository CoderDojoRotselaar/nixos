# Copy this file to include.secrets.sh and edit it

function _run_before_network() {
  # Example: configure WIFI

  # WIFI_SSID="my-ssid"
  # WIFI_PASSWORD="my-password"

  # wpa_cli -g "${WIFI_DEVICE}" remove_network 0 &>/dev/null
  # wpa_cli -g "${WIFI_DEVICE}" add_network
  # wpa_cli -g "${WIFI_DEVICE}" set_network 0 ssid "\"${WIFI_SSID}\""
  # wpa_cli -g "${WIFI_DEVICE}" set_network 0 psk "\"${WIFI_PASSWORD}\""

  # wpa_cli -g "${WIFI_DEVICE}" enable_network 0

  # _test_network 30
  :
}
function _run_before_install() {
  :
}
function _run_after_install() {
  :
}
