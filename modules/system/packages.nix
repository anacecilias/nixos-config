{ pkgs, ... }:
{
  # gtk2 foi marcado como obsoleto no nixpkgs; algum pacote ainda depende dele.
  # Remover quando o pacote responsável for atualizado.
  nixpkgs.config.problems.handlers."gtk+".broken = "warn";

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
