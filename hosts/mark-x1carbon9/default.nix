{ config, pkgs, ... }:

{
  imports = [
    ./hardware

    ../common/base.nix
    ../common/boot/efi.nix
    ../common/desktop/gnome.nix
    ../common/desktop/wayland.nix
  ];

  networking.hostName = "mark-x1carbon9"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  virtualisation.docker.enable = true;
}
