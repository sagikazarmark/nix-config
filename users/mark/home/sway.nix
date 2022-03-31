{ config, lib, pkgs, ... }:

let
  colorscheme = config.colorscheme;
in
{
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

      colors = {
        focused = {
          border = "${colorscheme.colors.base0C}";
          background = "${colorscheme.colors.base00}";
          text = "${colorscheme.colors.base05}";
          indicator = "${colorscheme.colors.base09}";
          childBorder = "${colorscheme.colors.base0C}";
        };
        focusedInactive = {
          border = "${colorscheme.colors.base03}";
          background = "${colorscheme.colors.base00}";
          text = "${colorscheme.colors.base04}";
          indicator = "${colorscheme.colors.base03}";
          childBorder = "${colorscheme.colors.base03}";
        };
        unfocused = {
          border = "${colorscheme.colors.base02}";
          background = "${colorscheme.colors.base00}";
          text = "${colorscheme.colors.base03}";
          indicator = "${colorscheme.colors.base02}";
          childBorder = "${colorscheme.colors.base02}";
        };
        urgent = {
          border = "${colorscheme.colors.base09}";
          background = "${colorscheme.colors.base00}";
          text = "${colorscheme.colors.base03}";
          indicator = "${colorscheme.colors.base09}";
          childBorder = "${colorscheme.colors.base09}";
        };
      };

      startup = [
        # { command = "${config.programs.waybar.package}/bin/waybar"; }
        { command = "systemctl --user restart waybar"; }
      ];

      bars = [ ];
    };

    # https://github.com/NixOS/nixpkgs/issues/119445#issuecomment-820507505
    extraConfig = ''
      exec dbus-update-activation-environment WAYLAND_DISPLAY
      exec systemctl --user import-environment WAYLAND_DISPLAY
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
}
