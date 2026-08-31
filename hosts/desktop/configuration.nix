{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # dont change this value after initial installation
  # controls state compatibility across nixos updates
  system.stateVersion = "24.05";
}