{
  # sound configuration with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # required for 32-bit application compatibility
    pulse.enable = true;
    jack.enable = true;
  };

  # bluetooth configuration
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # enable printing service
  # services.printing.enable = true;
}