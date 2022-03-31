{ pkgs, ... }:

{
  home.packages = [
    pkgs.libsForQt5.qt5.qtwayland
    pkgs.qt5ct
    # pkgs.libsForQt5.qt5.qt5ct
  ];

  wayland.windowManager.sway = {
    extraSessionCommands = ''
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

      export QT_QPA_PLATFORMTHEME=qt5ct
    '';
  };
}
