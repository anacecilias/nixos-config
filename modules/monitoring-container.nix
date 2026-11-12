{ config, pkgs, ... }:

{
  # enable container support on the host
  boot.enableContainers = true;

  # enable node_exporter on the host to collect hardware metrics
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [ "cpu" "meminfo" "diskstats" "filesystem" ];
  };

  # open the node_exporter port in the host firewall for the container
  networking.firewall.interfaces."ve-monitoring".allowedTCPPorts = [ 9100 ];

  # nixos native container declaration with prometheus + grafana
  containers.monitoring = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.1";
    localAddress = "192.168.100.2";

    # data persistence outside the container's ephemeral storage
    bindMounts = {
      "/var/lib/prometheus" = {
        hostPath = "/var/lib/nixos-containers/monitoring/prometheus";
        isReadOnly = false;
      };
      "/var/lib/grafana" = {
        hostPath = "/var/lib/nixos-containers/monitoring/grafana";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      system.stateVersion = "24.11";

      # internal prometheus configuration
      services.prometheus = {
        enable = true;
        port = 9090;
        scrapeConfigs = [
          {
            job_name = "nixos-host";
            static_configs = [
              { targets = [ "192.168.100.1:9100" ]; }
            ];
          }
          {
            job_name = "monitoring-container";
            static_configs = [
              { targets = [ "127.0.0.1:9090" ]; }
            ];
          }
        ];
      };

      # grafana configuration with automatic provisioning
      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "0.0.0.0";
            http_port = 3000;
            domain = "localhost";
          };
        };
        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:9090";
              isDefault = true;
            }
          ];
          dashboards.settings.providers = [
            {
              name = "Official Dashboards";
              options.path = "/etc/grafana/dashboards";
            }
          ];
        };
      };

      # copy the versioned dashboard json from the repository into the container
      environment.etc = {
        "grafana/dashboards/metrics-overview.json" = {
          source = ./dashboards/metrics-overview.json;
          mode = "0644";
        };
      };

      networking.firewall.allowedTCPPorts = [ 9090 3000 ];
    };
  };
}