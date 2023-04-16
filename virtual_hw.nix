{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.kernelModules = ["kvm-amd"];
  boot.loader.grub.device = "/dev/vda";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
