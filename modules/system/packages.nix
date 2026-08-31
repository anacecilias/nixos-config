{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Ferramentas de terminal
    vim
    git
    wget
    curl
    htop
    unzip
    p7zip
    fastfetch

    # Aplicativos do dia a dia
    firefox
    vscode
    discord
    spotify
    vlc
    gimp

    # Úteis para o KDE Plasma
    kdePackages.kate
    kdePackages.ark
    kdePackages.filelight
  ];
}
