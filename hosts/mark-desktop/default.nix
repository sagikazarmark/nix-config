{ config, pkgs, ... }:

{
  imports = [
    ./hardware

    ../common/base.nix
    ../common/boot/efi.nix
    ../common/desktop/gnome.nix
    ../common/desktop/wayland.nix

    ../common/services/ssh.nix

    ../common/logitech.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mark-desktop"; # Define your hostname.

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
