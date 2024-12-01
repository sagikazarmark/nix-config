{ ... }:

{
  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    keyMap = "hu";
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "hu";
  # services.xserver.xkbOptions = "eurosign:e";
}
