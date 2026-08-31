# ATENÇÃO: este é apenas um placeholder.
#
# Substitua este arquivo pelo hardware-configuration.nix real da sua
# máquina, normalmente encontrado em /etc/nixos/hardware-configuration.nix.
# Ele é gerado automaticamente pelo `nixos-generate-config` e contém
# informações específicas do seu hardware (discos, UUIDs, módulos de
# kernel necessários, CPU, etc).
#
# Para copiar o arquivo real para este repositório:
#   cp /etc/nixos/hardware-configuration.nix ./hosts/desktop/hardware-configuration.nix

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
