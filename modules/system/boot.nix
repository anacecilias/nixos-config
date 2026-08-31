{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # latest linux kernel, recommended for newer hardware
  boot.kernelPackages = pkgs.linuxPackages_latest;
}