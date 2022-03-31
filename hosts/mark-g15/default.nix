{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../common/base.nix
    ../common/core.nix
    ../common/networking.nix
    ../common/i18n.nix
    ../common/nix.nix
    ../common/users.nix
    # ../common/gnome.nix
    ../common/wayland.nix
    ../common/opengl.nix
    ../common/security.nix
    ../common/audio.nix
    ../common/fonts.nix
    ../common/services/ssh.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://github.com/NixOS/nixpkgs/issues/166410
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mark-g15"; # Define your hostname.

  networking.interfaces.enp3s0.useDHCP = true;

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
