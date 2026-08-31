{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history.size = 10000;

    shellAliases = {
      ll = "ls -la";
      gc = "sudo nix-collect-garbage -d";
      # Ajuste o caminho abaixo para onde você clonar este repositório
      update = "sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)";
    };
  };

  # Prompt bonito e informativo (mostra branch de git, status, etc)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
