{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../common/base.nix
    ../common/boot/efi.nix
    ../common/desktop/gnome.nix
    ../common/desktop/wayland.nix

    ../common/services/ssh.nix

    ../common/logitech.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mark-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.interfaces.enp12s0f3u4.useDHCP = true;
  networking.interfaces.enp7s0.useDHCP = true;

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
