{
  description = "NixOS configuration with flakes";

  # To update all inputs:
  # $ nix flake update --recreate-lock-file
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:rycee/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    retiolum.url = "git+https://git.thalheim.io/Mic92/retiolum";

    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;
  };

  outputs =
    { self
    , nixpkgs
    , nur
    , home-manager
    , retiolum
    , nixos-hardware
    , flake-registry
    }: {
    nixosConfigurations = import ./configurations.nix {
      inherit nixpkgs nur home-manager retiolum flake-registry;
      nixosSystem = nixpkgs.lib.nixosSystem;
    };
  };
}