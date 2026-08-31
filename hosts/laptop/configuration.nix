{ config, pkgs, inputs, ... }:
{
  imports = [
    # Gerado pelo instalador do NixOS nesta máquina.
    # Substitua pelo arquivo real de /etc/nixos/hardware-configuration.nix
    ./hardware-configuration.nix
  ];

  # ⚠️ Ajuste para o nome que quiser dar a esta máquina
  networking.hostName = "nixos-laptop";
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
