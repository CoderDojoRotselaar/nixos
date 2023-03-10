{
  config,
  lib,
  pkgs,
  modulePath,
  ...
}: {
  boot.loader.grub.device = "/dev/vda";
}
