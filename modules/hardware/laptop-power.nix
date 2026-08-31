{
  # TLP power management (conflicts with power-profiles-daemon)
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Battery charge thresholds (prolongs battery lifespan; hardware dependent)
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # thermal management
  services.thermald.enable = true;

  # laptop lid action
  services.logind.lidSwitch = "suspend";

  # wifi power saving, disable if connection becomes unstable
  networking.networkmanager.wifi.powersave = true;

  # deep sleep state
  boot.kernelParams = [ "mem_sleep_default=deep" ];
}