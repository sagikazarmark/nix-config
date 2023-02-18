{ config, pkgs, ... }:

{
  imports = [
    ./hardware

    ../common/base.nix
    ../common/boot/efi.nix
    ../common/desktop/gnome.nix
    ../common/desktop/wayland.nix

    # Users
    ../../users/mark/system
  ];

  networking.hostName = "mark-x1carbon9"; # Define your hostname.

  virtualisation.docker.enable = true;
}
