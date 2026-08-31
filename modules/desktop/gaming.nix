{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Abre portas para Steam Remote Play
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true; # Permite rodar jogos via Gamescope
  };

  # Otimiza automaticamente CPU/GPU (governor, etc) enquanto um jogo roda
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    lutris # Gerenciador de jogos (GOG, Epic, Battle.net via Wine)
    mangohud # Overlay de FPS/temperatura/uso de CPU-GPU
    protonup-qt # Instala versões customizadas do Proton (Proton-GE, etc)
  ];
}
