{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
  };

  # optimize cpu/gpu performance while games are running
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    protonup-qt
  ];
}