{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    corefonts # Fontes da Microsoft (Arial, Times, etc)
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    # Fonte para programação/terminal (ícones de dev, git, etc)
    # OBS: o antigo `nerdfonts.override { fonts = [...] }` foi descontinuado;
    # agora cada fonte é um pacote individual em pkgs.nerd-fonts.*
    nerd-fonts.fira-code
  ];
}
