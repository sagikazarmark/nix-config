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
    ../common/audio.nix
    ../common/services/ssh.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_5_15;

  networking.hostName = "mark-g15"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.interfaces.enp3s0.useDHCP = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver = {
    #enable = true;
    #layout = "hu";
    # windowManager.bspwm.enable = true;
    # windowManager.i3.enable = true;
    #windowManager.default = "bspwm";
    # desktopManager.xterm.enable = false;
    #displayManager.defaultSession = "none+bspwm";
    # displayManager.lightdm.enable = true;
    # displayManager.startx.enable = false;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #   wget
    #   firefox
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
