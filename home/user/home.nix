{ pkgs, username, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/shell.nix
    ./programs/terminal.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # dont change this value after initial installation
  # controls state compatibility across home manager updates
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    btop
  ];
}