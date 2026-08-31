{
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
}
