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
      # update path to match your local repository clone directory
      update = "sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}