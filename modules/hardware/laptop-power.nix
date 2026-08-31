{
  # TLP gerencia energia melhor que o padrão do systemd em notebooks.
  # Ele conflita com power-profiles-daemon, então desabilitamos o segundo.
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Limites de carga da bateria (prolonga a vida útil). Nem todo
      # hardware suporta isso — se der erro ao aplicar, remova estas
      # duas linhas ou ajuste o nome do dispositivo (BAT0/BAT1).
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Gestão térmica (evita throttling agressivo/barulho excessivo)
  services.thermald.enable = true;

  # Suspende ao fechar a tampa
  services.logind.lidSwitch = "suspend";

  # Economiza bateria no Wi-Fi (pode causar instabilidade em alguns
  # chipsets — desative se notar quedas de conexão)
  networking.networkmanager.wifi.powersave = true;

  # Sono mais profundo (economiza mais bateria no S3/S2idle)
  boot.kernelParams = [ "mem_sleep_default=deep" ];
}
