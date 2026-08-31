{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    # terminal nerd font
    nerd-fonts.fira-code
  ];
}