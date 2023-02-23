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

  # Experimenting with 1password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["mark"];
  };
}
