{ pkgs, ... }:

{
  # virtualisation.docker = {
  #   enable = true;
  # };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman-compose
  ];

  hardware.nvidia-container-toolkit.enable = true;
}
