{ config, pkgs, ... }:

{
  imports = [
    ./hardware

    ../common/nixos/base.nix
    ../common/nixos/core.nix
    ../common/nixos/boot/efi.nix
    ../common/nixos/desktop/wayland.nix
    ../common/nixos/theme.nix

    ../common/nixos/services/ssh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # withUWSM = true;

    # systemd.setPath.enable = true;
  };

  # programs.uwsm.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  programs.hyprlock.enable = true;
  # services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [

    wofi
    clinfo
    # davinci-resolve-studio
  ];

  environment.sessionVariables = {
    #If your cursor becomes invisible
    #WLR_NO_HARDWARE_CURSORS = "1";
    #Hint electron apps to use wayland
    #NIXOS_OZONE_WL = "1";
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
