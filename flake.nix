{
  description = "multi host nixos configuration template (desktop + laptop) with KDE plasma and gaming support";

  inputs = {
    # nixos unstable for latest packages and kernel features
    # change to a stable release (e.g., "nixos-24.11") for higher stability
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # set primary user username used across all configurations
      username = "changeme";

      # shared modules included across all host configurations
      commonModules = [
        ./modules/system/boot.nix
        ./modules/system/locale.nix
        ./modules/system/maintenance.nix
        ./modules/system/packages.nix
        ./modules/system/fonts.nix
        ./modules/system/secrets.nix

        ./modules/desktop/plasma.nix
        ./modules/desktop/audio.nix
        ./modules/desktop/gaming.nix

        ./modules/hardware/graphics.nix

        ./modules/users/user.nix

        sops-nix.nixosModules.sops

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs username; };
          home-manager.users.${username} = import ./home/user/home.nix;
        }
      ];
    in
    {
      nixosConfigurations = {
        # Desktop configuration (NVIDIA GPU setup, no laptop power management)
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = commonModules ++ [
            ./hosts/desktop/configuration.nix
            ./modules/hardware/nvidia.nix
          ];
        };

        # laptop configuration (power management via TLP/thermald)
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = commonModules ++ [
            ./hosts/laptop/configuration.nix
            ./modules/hardware/laptop-power.nix
          ];
        };
      };

      # development shell providing secrets management tools (`nix develop`)
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ git sops age ];
      };
    };
}