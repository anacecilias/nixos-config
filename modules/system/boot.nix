{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel mais recente — bom para hardware moderno (ex.: GPUs novas)
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
