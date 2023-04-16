{
  config,
  lib,
  modulesPath,
  ...
}: {
  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.kernelModules = ["kvm-amd"];
  boot.loader.grub.device = "/dev/sda";
  fileSystems."/boot".device = "/dev/sda1";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
