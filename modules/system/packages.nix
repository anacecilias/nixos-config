{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # terminal tools
    vim
    git
    wget
    curl
    htop
    unzip
    p7zip
    fastfetch

    # daily apps
    firefox
    vscode
    discord
    spotify
    vlc
    gimp

    # KDE plasma utils
    kdePackages.kate
    kdePackages.ark
    kdePackages.filelight
  ];
}
