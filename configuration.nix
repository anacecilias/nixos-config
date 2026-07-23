{ config, pkgs, ... }:

{
  imports = [
    # O arquivo de hardware gerado na instalação será importado aqui
    ./hardware-configuration.nix
  ];

  # ==========================================
  # 1. BOOT E KERNEL
  # ==========================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Usa um kernel mais recente (ótimo para hardware moderno)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ==========================================
  # 2. REDE E LOCALIZAÇÃO
  # ==========================================
  networking.hostName = "nixos-pc";
  
  # Gerenciador de rede gráfico (Wi-Fi e Cabo)
  networking.networkmanager.enable = true;

  # Fuso horário e Idiomas
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Teclado em Português (ABNT2) no Terminal e na Interface
  console.keyMap = "br-abnt2";
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # ==========================================
  # 3. INTERFACE GRÁFICA E ÁUDIO
  # ==========================================
  # Habilita o X11 / Wayland e o ambiente KDE Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Áudio moderno com Pipewire (evita problemas em jogos e chamadas)
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Importante para jogos antigos/Steam
    pulse.enable = true;
    jack.enable = true;
  };

  # Suporte a Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Impressoras e Escâneres (descomente se usar)
  # services.printing.enable = true;

  # ==========================================
  # 4. DRIVERS NVIDIA
  # ==========================================
  nixpkgs.config.allowUnfree = true; # Permite drivers/softwares proprietários
  
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # Mantenha false para drivers proprietários estáveis
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Habilita aceleração 3D e suporte a 32-bits (essencial para Steam/Wine)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ==========================================
  # 5. USUÁRIO E SEGURANÇA
  # ==========================================
  users.users.ana = {
    isNormalUser = true;
    description = "Ana";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
  };

  # Suporte a Flatpak (útil caso um app não esteja no repositório do Nix)
  services.flatpak.enable = true;

  # ==========================================
  # 6. PACOTES E FONTES DO SISTEMA
  # ==========================================
  environment.systemPackages = with pkgs; [
    # Ferramentas do Terminal
    vim
    git
    wget
    curl
    htop
    unzip
    p7zip
    fastfetch

    # Aplicativos do Dia a Dia
    firefox
    vscode
    discord
    spotify
    vlc
    gimp

    # Úteis para o KDE Plasma
    kdePackages.kate
    kdePackages.ark
    kdePackages.filelight # Utilitário para ver uso de disco
  ];

  # Instala fontes populares para não ter texto quebrado na web
  fonts.packages = with pkgs; [
    corefonts # Fontes da Microsoft (Arial, Times, etc)
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    (nerdfonts.override { plugins = [ "FiraCode" ]; }) # Fonte para programação no VS Code
  ];

  # ==========================================
  # 7. MANUTENÇÃO AUTOMÁTICA
  # ==========================================
  # Limpa versões antigas do sistema semanalmente para não encher o HD
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Otimiza o armazenamento do Nix automaticamente
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "24.05";
}