{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations."cdjvm-jovdg-1" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./virtual_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdjvm-jovdg-1";})
      ];
    };
    nixosConfigurations."cdj-rots-114" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-114";})
      ];
    };
    nixosConfigurations."cdj-rots-110" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-110";})
      ];
    };
    nixosConfigurations."cdj-rots-102" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-102";})
      ];
    };
    nixosConfigurations."cdj-rots-112" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-112";})
      ];
    };
    nixosConfigurations."cdj-rots-109" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-109";})
      ];
    };
    nixosConfigurations."cdj-rots-106" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-106";})
      ];
    };
    nixosConfigurations."cdj-rots-104" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-104";})
      ];
    };
    nixosConfigurations."cdj-rots-101" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-101";})
      ];
    };
    nixosConfigurations."cdj-rots-111" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-111";})
      ];
    };
    nixosConfigurations."cdj-rots-113" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-113";})
      ];
    };
    nixosConfigurations."cdj-rots-105" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-105";})
      ];
    };
    nixosConfigurations."cdj-rots-108" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-108";})
      ];
    };
    nixosConfigurations."cdj-rots-100" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-100";})
      ];
    };
    nixosConfigurations."cdj-rots-103" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-103";})
      ];
    };
    nixosConfigurations."cdj-rots-107" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./physical_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "cdj-rots-107";})
      ];
    };
    nixosConfigurations.coderdojo = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./virtual_hw.nix
        ./hardware.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {networking.hostName = "coderdojo";})
      ];
    };
  };
}
