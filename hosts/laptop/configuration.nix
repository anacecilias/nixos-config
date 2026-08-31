{ config, pkgs, inputs, ... }:

{
  imports = [
    # replace with your systems /etc/nixos/hardware-configuration.nix
    ./hardware-configuration.nix
  ];

  # set your system hostname
  networking.hostName = "nixos-laptop";
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # dont change this value after initial installation
  # controls state compatibility across nixos updates
  system.stateVersion = "24.05";
}