{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  colorscheme = config.colorscheme;
  ccolors = import ./colors.nix { inherit lib; };
  inherit (ccolors) hexColor rgbaColor colors;
in
{
  imports = [
    ./qt.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard

    eog

    # for dunst
    notify-desktop

    # for screenshots
    grim
    slurp

    # play screenshot sound
    mpv

    lr-tech-rofi-themes
  ];

  wayland.windowManager.sway = {
    enable = true;

    systemd.enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${config.programs.rofi.package}/bin/rofi -show run";

      # Note: make sure to use lower-case for "space" to override defaults.
      keybindings =
        let
          processScreenshot = ''wl-copy -t image/png && mpv ${config.xdg.dataHome}/sounds/shutter.mp3 && notify-desktop "Screenshot taken"'';
        in
        lib.mkOptionDefault {
          # Start a terminal
          "${modifier}+Return" = "exec ${terminal}";

          # Start your launcher
          "${modifier}+space" = "exec ${menu}";

          # Kill focused window
          "${modifier}+w" = "kill";

          # Reload configuration
          "${modifier}+Alt+r" = "reload";

          # Exit sway
          "${modifier}+Alt+q" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          # Make the current focus fullscreen
          "${modifier}+m" = "fullscreen toggle";

          # Toggle the current focus between tiling and floating mode
          "${modifier}+t" = "floating toggle";

          # Screenshot
          # "${modifier}+Shift+F3" = ''exec grim - | ${processScreenshot}'';
          "${modifier}+Shift+F3" = "exec bash ${config.xdg.dataHome}/scripts/screenshot.sh";
          # "${modifier}+Shift+F4" = ''exec grim -g "$(slurp -d)" - | ${processScreenshot}'';
          "${modifier}+Shift+F4" = "exec bash ${config.xdg.dataHome}/scripts/screenshot-area.sh";

          "XF86TouchpadToggle" = "input type:touchpad events toggle enabled disabled";
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
          dwt = "enabled";
        };
      };

      # output = {
      #   "*" = {
      #     bg = "~/Pictures/Wallpaper/wallhaven-m9o9e9.jpg fill";
      #   };
      # };

      startup = [
        # { command = "${config.programs.waybar.package}/bin/waybar"; }
        # { command = "systemctl --user restart waybar"; }
      ];

      bars = [ ];

      gaps = {
        horizontal = 5;
        inner = 20;
      };
    };

    # https://github.com/NixOS/nixpkgs/issues/119445#issuecomment-820507505
    extraConfig = ''
      for_window [app_id="firefox" title="Firefox — Sharing Indicator"] floating enable
      for_window [app_id="firefox" title="Picture-in-Picture"] floating enable
      for_window [app_id="firefox" title="About Mozilla Firefox"] floating enable

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

  # TODO: move to overlay in sway?
  # programs.zsh.loginExtra = lib.mkBefore ''
  #   if [[ "$(tty)" == /dev/tty1 ]]; then
  #     exec sway &> /dev/null
  #   fi
  # '';

  programs.fish.loginShellInit = lib.mkBefore ''
    if test (tty) = /dev/tty1
      exec sway &> /dev/null
    end
  '';

  programs.bash.profileExtra = lib.mkBefore ''
    if [[ "$(tty)" == /dev/tty1 ]]; then
      exec sway &> /dev/null
    fi
  '';

  xdg.dataFile =
    let
      processScreenshot = ''wl-copy -t image/png && mpv ${config.xdg.dataHome}/sounds/shutter.mp3 && notify-desktop "Screenshot taken"'';
    in
    {
      "scripts/screenshot.sh" = {
        text = ''
          #/usr/bin/env bash

          set -e
          set -o pipefail

          grim - | ${processScreenshot}
        '';
      };
      "scripts/screenshot-area.sh" = {
        text = ''
          #/usr/bin/env bash

          set -e
          set -o pipefail

          grim -g "$(slurp -d)" - | ${processScreenshot}
        '';
      };
    };

  programs.rofi = {
    enable = true;

    plugins = [
      pkgs.rofi-power-menu
      pkgs.rofi-calc
      pkgs.rofi-emoji
    ];

    terminal = "${pkgs.kitty}/bin/kitty";
  };

  # programs.waybar = {
  #   enable = true;
  #
  #   systemd = {
  #     enable = true;
  #     target = "sway-session.target";
  #   };
  #
  #   settings = {
  #     mainBar = {
  #       height = 40;
  #       modules-left = [ "sway/workspaces" "sway/mode" ];
  #       modules-center = [ ];
  #       modules-right = [
  #         "pulseaudio"
  #         "idle_inhibitor"
  #         "network"
  #         "temperature"
  #         "memory"
  #         "cpu"
  #         "battery"
  #         "clock"
  #         "tray"
  #       ];
  #
  #       # backlight = {
  #       #   format = "{icon}";
  #       #   format-alt = "{percent}% {icon}";
  #       #   format-alt-click = "click-right";
  #       #   format-icons = [ "○" "◐" "●" ];
  #       #   on-scroll-down = "light -U 10";
  #       #   on-scroll-up = "light -A 10";
  #       # };
  #       battery = {
  #         format = "{capacity}% {icon}";
  #         format-icons = [ "" "" "" "" "" ];
  #         states = {
  #           warning = 30;
  #           critical = 15;
  #         };
  #       };
  #       clock = {
  #         tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
  #         format-alt = "{:%A, %d %b}";
  #       };
  #       cpu = {
  #         format = "{usage}% ";
  #       };
  #       idle_inhibitor = {
  #         format = "{icon}";
  #         format-icons = {
  #           activated = "";
  #           deactivated = "";
  #         };
  #       };
  #       memory = {
  #         format = "{}% ";
  #         format-alt = "{used:0.1f}G/{total:0.1f}G ";
  #       };
  #       network = {
  #         format = "{ifname}";
  #         format-alt = "⬇️ {bandwidthDownBits} / ⬆️ {bandwidthUpBits}";
  #         format-wifi = "{essid} ({signalStrength}%) ";
  #         format-ethernet = "{ipaddr}/{cidr} ";
  #         format-linked = "no ip ";
  #         format-disconnected = "Disconnected ";
  #         tooltip-format = "{ifname} via {gwaddr} ";
  #         tooltip-format-wifi = "{essid} ({signalStrength}%) ";
  #         tooltip-format-ethernet = "{ifname} ";
  #         tooltip-format-disconnected = "Disconnected";
  #
  #         on-click-middle = "nm-connection-editor";
  #       };
  #       pulseaudio = {
  #         format = "{volume}% {icon} {format_source}";
  #         format-bluetooth = "{volume}% {icon} {format_source}";
  #         format-bluetooth-muted = " {icon} {format_source}";
  #         format-muted = " {format_source}";
  #         format-source = "{volume}% ";
  #         format-source-muted = "";
  #         format-icons = {
  #           headphone = "";
  #           hands-free = "";
  #           headset = "";
  #           phone = "";
  #           portable = "";
  #           car = "";
  #           default = [ "" "" ];
  #         };
  #         scroll-step = 1;
  #         on-click = "pavucontrol";
  #       };
  #       temperature = {
  #         format = "{temperatureC}°C ";
  #       };
  #       tray = {
  #         spacing = 10;
  #       };
  #       "sway/workspaces" = {
  #         all-outputs = true;
  #         format = "{icon}";
  #         format-icons = {
  #           "1" = "";
  #           "2" = "";
  #           "3" = "";
  #           "4" = "";
  #           "5" = "";
  #           "6" = "";
  #           "7" = "";
  #           "9" = "";
  #           "10" = "";
  #           focused = "";
  #           urgent = "";
  #           default = "";
  #         };
  #       };
  #       # "custom/media#0" = mkIf audioSupport (media { number = 0; });
  #       # "custom/media#1" = mkIf audioSupport (media { number = 1; });
  #       # "custom/power" = {
  #       #   format = "";
  #       #   on-click = "nwgbar -o 0.2";
  #       #   escape = true;
  #       #   tooltip = false;
  #       # };
  #     };
  #   };
  #
  #
  #   style = builtins.readFile ../../../dotfiles/waybar/styles/desert.css;
  # };

  services.dunst = {
    enable = true;
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
