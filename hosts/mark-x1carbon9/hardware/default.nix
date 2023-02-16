{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    ./generated.nix

    inputs.hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
  ];

  boot.initrd.luks.devices = {
    nixos-enc = {
      device = "/dev/nvme0n1p2";
      preLVM = true;

      # According to the documentation this setting has security implications.
      # https://search.nixos.org/options?channel=unstable&show=boot.initrd.luks.devices.%3Cname%3E.allowDiscards&from=0&size=50&sort=relevance&type=packages&query=boot.initrd.luks.devices
      # https://wiki.archlinux.org/title/Dm-crypt/Specialties#Discard/TRIM_support_for_solid_state_drives_(SSD)
      allowDiscards = true;
    };
  };

  networking.interfaces.wlp0s20f3.useDHCP = true;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  hardware.bluetooth.enable = true;
}
