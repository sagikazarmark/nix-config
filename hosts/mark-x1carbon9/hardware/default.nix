{ pkgs, inputs, ... }:

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

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  networking.interfaces.wlp0s20f3.useDHCP = true;

  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Fingerprint reader
  services.fprintd.enable = true;

  # Make top speakers work
  environment.systemPackages = [
    pkgs.easyeffects
  ];
}
