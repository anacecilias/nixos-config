{
  description = "Template de configuração NixOS multi-host (desktop + laptop), KDE Plasma + gaming";

  inputs = {
    # nixos-unstable dá acesso a pacotes/kernel mais recentes.
    # Se preferir mais estabilidade, troque para "nixos-24.05" (mesma
    # branch do stateVersion usado abaixo).
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

      # ─────────────────────────────────────────────────────────────
      # ÚNICO lugar que você precisa editar para "batizar" este
      # template com o seu usuário. Tudo abaixo (users, home-manager,
      # aliases) referencia esta variável.
      username = "changeme";
      # ─────────────────────────────────────────────────────────────

      # Módulos compartilhados por TODOS os hosts. Cada host adiciona por
      # cima seus módulos específicos (ex.: nvidia.nix vs laptop-power.nix).
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
        # Desktop: GPU NVIDIA dedicada, sem gestão de energia de notebook.
        # Renomeie a chave "desktop" se quiser um nome de host diferente.
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = commonModules ++ [
            ./hosts/desktop/configuration.nix
            ./modules/hardware/nvidia.nix
          ];
        };

        # Laptop: sem NVIDIA (ajuste se o seu tiver GPU dedicada/Optimus),
        # com TLP/thermald para bateria.
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = commonModules ++ [
            ./hosts/laptop/configuration.nix
            ./modules/hardware/laptop-power.nix
          ];
        };
      };

      # `nix develop` nesta pasta dá acesso a sops/age para editar segredos.
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ git sops age ];
      };
    };
}
