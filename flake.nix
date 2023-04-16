{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nix.binaryCaches = [
      "http://nixcache.internal.dwarfy.be/"
      # "http://cache.nixos.org/" # include this line if you want it to fallback to upstream if your cache is down
    ];

    nixosConfigurations."8624a900-42e2-4f13-a04d-9a961eb1016d" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
