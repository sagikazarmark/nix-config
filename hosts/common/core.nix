{ config, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    cantarell-fonts
    dejavu_fonts
    source-code-pro # Default monospace font in 3.32
    source-sans
  ];

  security.polkit.enable = true;

  services.power-profiles-daemon.enable = true;

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.gtkUsePortal = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  # Harmonize Qt5 application style and also make them use the portal for file chooser dialog.
  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };

  services.avahi = {
    enable = true;

    openFirewall = true;
  };

  # needed for opengpg pinentry gnome3
  services.dbus.packages = [ pkgs.gcr ];


  # needed for setting gtk themes
  programs.dconf.enable = true;

  # needed for diskmounting in dolphin
  services.udisks2.enable = true;

  services.upower.enable = config.powerManagement.enable;
}
