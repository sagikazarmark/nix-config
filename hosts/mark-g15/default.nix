{ config, pkgs, ... }:

{
  imports = [
    ./hardware

    ../common/base.nix
    ../common/core.nix
    ../common/boot/efi.nix
    ../common/desktop/wayland.nix

    ../common/services/ssh.nix
  ];

  # https://github.com/NixOS/nixpkgs/issues/166410
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mark-g15"; # Define your hostname.

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
