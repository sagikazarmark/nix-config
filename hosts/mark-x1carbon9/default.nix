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
    polkitPolicyOwners = [ "mark" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
