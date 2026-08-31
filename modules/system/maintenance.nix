{
  # Habilita o comando `nix` novo e o suporte a flakes no sistema
  # (necessário para usar `nixos-rebuild switch --flake`)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Limpa gerações antigas do sistema semanalmente
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Otimiza o armazenamento do Nix automaticamente (deduplica /nix/store)
  nix.settings.auto-optimise-store = true;
}
