{ config, lib, pkgs, inputs, ... }:

let
  colorscheme = config.colorscheme;
in
{
  imports = [
    ./qt.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
  ];

  wayland.windowManager.sway = {
    enable = true;

    systemdIntegration = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${config.programs.rofi.package}/bin/rofi -show run";

      # Note: make sure to use lower-case for "space" to override defaults.
      keybindings = lib.mkOptionDefault {
        # Start a terminal
        "${modifier}+Return" = "exec ${terminal}";

        # Start your launcher
        "${modifier}+space" = "exec ${menu}";

        # Kill focused window
        "${modifier}+w" = "kill";

        # Reload configuration
        "${modifier}+Alt+r" = "reload";

        # Exit sway
        "${modifier}+Alt+q" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        # Make the current focus fullscreen
        "${modifier}+m" = "fullscreen toggle";

        # Toggle the current focus between tiling and floating mode
        "${modifier}+t" = "floating toggle";
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "hu";
          xkb_options = "caps:super";
          # xkb_options = "caps:super,apple:alupckeys,compose:rwin";

          repeat_delay = "225";
          repeat_rate = "30";
        };

        "type:touchpad" = {
          tap = "enabled";
          tap_button_map = "lrm";
          natural_scroll = "enabled";
        };
      };

      startup = [
        # { command = "${config.programs.waybar.package}/bin/waybar"; }
        # { command = "systemctl --user restart waybar"; }
      ];

      bars = [ ];
    };

    # https://github.com/NixOS/nixpkgs/issues/119445#issuecomment-820507505
    extraConfig = ''
      exec dbus-update-activation-environment WAYLAND_DISPLAY
      exec systemctl --user import-environment WAYLAND_DISPLAY
    '';

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    extraOptions = [ "--unsupported-gpu" ];
    # ++ lib.optionals (lib.elem "nvidia" sysconfig.services.xserver.videoDrivers) [ "--unsupported-gpu" ];
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    terminal = "${pkgs.kitty}/bin/kitty";
  };

  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      # target = "sway-session.target";
    };
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # cursorTheme = pkgs.numix-cursor-theme;
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
    };
  };
}
