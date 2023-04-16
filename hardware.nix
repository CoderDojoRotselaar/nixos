{lib, ...}: {
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.extraModulePackages = [];

  fileSystems = {
    "/" = {
      device = "/dev/rootvg/root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/rootvg/boot";
      fsType = "ext4";
    };
    "/var" = {
      device = "/dev/rootvg/var";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/rootvg/home";
      fsType = "ext4";
    };
  };
  swapDevices = [
    {device = "/dev/rootvg/swap";}
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
