# ATENÇÃO: este é apenas um placeholder.
#
# Substitua este arquivo pelo hardware-configuration.nix real deste
# laptop, gerado por `nixos-generate-config` em /etc/nixos/.
#
#   cp /etc/nixos/hardware-configuration.nix ./hosts/laptop/hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # ⚠️ Conteúdo de exemplo — substitua pelo arquivo real antes de usar!
  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/PLACEHOLDER";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
