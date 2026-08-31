{ config, pkgs, inputs, ... }:
{
  imports = [
    # Gerado pelo instalador do NixOS na sua máquina.
    # Substitua pelo arquivo real de /etc/nixos/hardware-configuration.nix
    ./hardware-configuration.nix
  ];

  # ⚠️ Ajuste para o nome que quiser dar a esta máquina
  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;

  # Permite pacotes/drivers com licença proprietária (necessário para NVIDIA, etc.)
  nixpkgs.config.allowUnfree = true;

  # Não mude isso depois da instalação inicial — controla compatibilidade
  # de formato de dados entre versões do NixOS.
  system.stateVersion = "24.05";
}
