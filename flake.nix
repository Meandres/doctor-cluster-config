{
  description = "NixOS configuration with flakes";

  # To update all inputs:
  # $ nix flake update --recreate-lock-file
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    #nixpkgs.url = "github:NixOS/nixpkgs/release-21.05";
    nixpkgs.url = "github:Mic92/nixpkgs/release-21.05-backports";
    nixpkgs-systemd.url = "github:Mic92/nixpkgs/systemd";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:rycee/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    # optional, not necessary for the module
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    retiolum.url = "git+https://git.thalheim.io/Mic92/retiolum";

    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;

    vmsh.url = "github:Mic92/vmsh";
    vmsh.inputs.flake-utils.follows = "flake-utils";
    vmsh.inputs.nixpkgs.follows = "nixpkgs";

    lambda-pirate.url = "github:pogobanane/lambda-pirate";
    lambda-pirate.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-systemd
    , nur
    , home-manager
    , sops-nix
    , retiolum
    , nixos-hardware
    , flake-registry
    , flake-utils
    , vmsh
    , lambda-pirate
    }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.python3.pkgs.invoke
          pkgs.ipmitool
          pkgs.age
          pkgs.sops
        ];
      };
    }) //
    {
      nixosConfigurations = import ./configurations.nix {
        inherit nixpkgs nixpkgs-systemd nur home-manager retiolum flake-registry vmsh lambda-pirate sops-nix;
        nixosSystem = nixpkgs.lib.nixosSystem;
      };

      hydraJobs = nixpkgs.lib.mapAttrs' (name: config: nixpkgs.lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel) self.nixosConfigurations;
    };
}
