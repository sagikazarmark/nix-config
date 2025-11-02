{
  config,
  pkgs,
  inputs,
  ...
}:

{
  systemd.tmpfiles.rules = [
    "d /var/lib/comfyui 0755 1000 1000 -"
    "d /var/lib/comfyui/models 0755 1000 1000 -"
    "d /var/lib/comfyui/output 0755 1000 1000 -"
    "d /var/lib/comfyui/input 0755 1000 1000 -"
    "d /var/lib/comfyui/custom_nodes 0755 1000 1000 -"
  ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers.comfyui = {
      image = "localhost/comfy:latest";
      autoStart = true;

      ports = [
        "8188:8188"
      ];

      volumes = [
        "/var/lib/comfyui:/workspace/data"
      ];

      # GPU access (CDI format for NixOS 24.05+)
      extraOptions = [
        "--device=nvidia.com/gpu=all"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    8188
    7860
    7861
  ];
}
