{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    ./generated.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd

    ../../common/hardware/logitech.nix
  ];

  networking.interfaces.enp12s0f3u4.useDHCP = true;
  networking.interfaces.enp7s0.useDHCP = true;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
