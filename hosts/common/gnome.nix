# GNOME desktop environment
# https://nixos.wiki/wiki/GNOME
{ pkgs, ... }:

{
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = [
    pkgs.gnome.cheese
    pkgs.gnome-photos
    pkgs.gnome.gnome-music
    pkgs.gnome.gnome-terminal
    pkgs.gnome.gedit
    pkgs.epiphany
    pkgs.evince
    pkgs.gnome.gnome-characters
    pkgs.gnome.totem
    pkgs.gnome.tali
    pkgs.gnome.iagno
    pkgs.gnome.hitori
    pkgs.gnome.atomix
    pkgs.gnome-tour
    pkgs.gnome.geary
  ];

  # Required for the user to show up in GNOME
  # https://www.reddit.com/r/NixOS/comments/ocimef/users_not_showing_up_in_gnome/
  environment.shells = [ pkgs.zsh ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
  ];

  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
  services.dbus.packages = with pkgs; [ gnome2.GConf ];
}
