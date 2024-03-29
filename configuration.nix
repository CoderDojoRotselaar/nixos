# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  programs.xfconf.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.coderdojo = {
    imports = [./home.nix];
  };

  nix.settings = {
    connect-timeout = 1;
    fallback = true;
    substituters = [
      "https://nixcache.internal.dwarfy.be/"
    ];
  };

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
      # efiInstallAsRemovable = true;
      # boot.loader.efi.efiSysMountPoint = "/boot/efi";
      # Define on which hard drive you want to install Grub.
      # useOSProber = true;
    };
  };
  boot.loader.timeout = 3;

  services.sshd.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVM0O5oqaCoeYzYYmhVUBhUIik+WfDq8WaQf7f5NFkR jo@jo-desktop"
  ];

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
      xfce = {
        enableScreensaver = false;
        enable = true;
      };
    };
    displayManager = {
      lightdm = {
        enable = true;
      };
      autoLogin = {
        enable = true;
        user = "coderdojo";
      };
      defaultSession = "xfce";
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
    inotify-tools
    libreoffice
    neovim
    openssl
    ripgrep
    rufo
    syncthing
    vim
    wget
    file
    imagemagick
  ];

  system.autoUpgrade = {
    enable = true;
    persistent = true;
    flake = "/etc/nixos";
    randomizedDelaySec = "60min";
    flags = [
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

  nixpkgs.config.packageOverrides = pkgs: {
    nur =
      import (
        builtins.fetchTarball {
          url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
          # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
          sha256 = "0alb2m23f0vz413g022gn1016s02vy6k5mbz167j7lqy97izxbi3";
        }
      ) {
        inherit pkgs;
      };
  };
}
