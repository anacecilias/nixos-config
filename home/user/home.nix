{ pkgs, username, ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/shell.nix
    ./programs/terminal.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Deve acompanhar o stateVersion do sistema (não mude depois de definido)
  home.stateVersion = "24.05";

  # Permite que o home-manager gerencie a si mesmo
  programs.home-manager.enable = true;

  # Pacotes específicos do usuário (em vez de systemPackages)
  home.packages = with pkgs; [
    btop
  ];
}
