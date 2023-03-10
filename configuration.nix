# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  callPackage,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk.nix
    ./system.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader = {
    # efi = {
    #   canTouchEfiVariables = true;
    #   efiSysMountPoint = "/boot/EFI";
    # };
    # systemd-boot.enable = true;

    grub = {
      enable = true;
      version = 2;
      efiSupport = true;
      # efiInstallAsRemovable = true;
      # boot.loader.efi.efiSysMountPoint = "/boot/efi";
      # Define on which hard drive you want to install Grub.
      # useOSProber = true;
    };
  };
  boot.loader.timeout = 3;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "nl_BE.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  nixpkgs.config.pulseaudio = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      lxqt.enable = true;
      wallpaper.mode = "fill";
    };
    displayManager = {
      lightdm = {
        enable = true;
      };
      autoLogin = {
        enable = true;
        user = "coderdojo";
      };
      defaultSession = "lxqt";
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "be";
    xkbOptions = "eurosign:e";
  };
  #  "caps:escape" # map caps to escape.

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.coderdojo = {
    initialPassword = "coderdojo";
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    black
    dmidecode
    curl
    firefox
    gcompris
    gimp
    git
    git-crypt
    godot
    go
    lxqt.lximage-qt
    inotify-tools
    libreoffice
    neovim
    openssl
    ripgrep
    rufo
    syncthing
    tilix
    vim
    wget
  ];

  system.autoUpgrade = {
    enable = true;
    persistent = true;
    flake = "/etc/nixos#coderdojo";
    randomizedDelaySec = "60min";
    flags = [
      "--impure"
      "--upgrade-all"
      "--recreate-lock-file"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
