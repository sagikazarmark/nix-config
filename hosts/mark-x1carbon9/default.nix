{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../common/base.nix
    ../common/networking.nix
    ../common/i18n.nix
    ../common/nix.nix
    ../common/users.nix
    ../common/gnome.nix
    ../common/wayland.nix
    ../common/security.nix
    ../common/audio.nix
    ../common/fonts.nix
    ../common/services/ssh.nix

    # ../common/logitech.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mark-x1carbon9"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
