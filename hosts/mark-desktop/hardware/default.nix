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

  # Focusrite Scarlet Solo driver
  # https://github.com/Focusrite-Scarlett-on-Linux/sound-usb-kernel-module#enabling-new-functionality-at-load-time
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
  '';

  networking.interfaces.enp12s0f3u4.useDHCP = true;
  networking.interfaces.enp7s0.useDHCP = true;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
