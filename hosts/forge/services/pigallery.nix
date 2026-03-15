{
  config,
  pkgs,
  inputs,
  ...
}:

{
  systemd.tmpfiles.rules = [
    "d /var/lib/pigallery 0755 1000 1000 -"
    "d /var/lib/pigallery/config 0755 1000 1000 -"
    "d /var/lib/pigallery/db 0755 1000 1000 -"
    "d /var/lib/pigallery/tmp 0755 1000 1000 -"
  ];

  virtualisation.oci-containers = {
    containers.pigallery = {
      image = "bpatrik/pigallery2:latest";
      autoStart = true;

      environment = {
        NODE_ENV = "production";
      };

      ports = [
        "3080:80"
      ];

      volumes = [
        "/var/lib/pigallery/config:/app/data/config"
        "/var/lib/pigallery/db:/app/data/db"
        "/var/lib/pigallery/tmp:/app/data/tmp"
        "/var/lib/comfyui/output:/app/data/images:ro"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    3080
  ];
}
