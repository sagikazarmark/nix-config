{ config, lib, pkgs, inputs, ... }:

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

    gnome.eog


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

    systemdIntegration = true;
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
          "${modifier}+Alt+q" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          # Make the current focus fullscreen
          "${modifier}+m" = "fullscreen toggle";

          # Toggle the current focus between tiling and floating mode
          "${modifier}+t" = "floating toggle";

          # Screenshot
          # "${modifier}+Shift+F3" = ''exec grim - | ${processScreenshot}'';
          "${modifier}+Shift+F3" = "exec bash ${config.xdg.dataHome}/scripts/screenshot.sh";
          # "${modifier}+Shift+F4" = ''exec grim -g "$(slurp -d)" - | ${processScreenshot}'';
          "${modifier}+Shift+F4" = "exec bash ${config.xdg.dataHome}/scripts/screenshot-area.sh";
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

      output = {
        "*" = {
          bg = "~/Pictures/Wallpaper/wallhaven-m9o9e9.jpg fill";
        };
      };

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
  programs.zsh.loginExtra = lib.mkBefore ''
    if [[ "$(tty)" == /dev/tty1 ]]; then
      exec sway &> /dev/null
    fi
  '';

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

    package = pkgs.rofi-wayland;
    plugins = [
      pkgs.rofi-power-menu
      pkgs.rofi-calc
      pkgs.rofi-emoji
    ];

    terminal = "${pkgs.kitty}/bin/kitty";
  };

  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      # target = "sway-session.target";
    };

    # style = ''
    #   @import "colors/base16-${config.programs.waybar.nix-colors.colorscheme.slug}.css";

    #   * {
    #     transition: none;
    #     box-shadow: none;
    #   }

    #   #waybar {
    #     color: @base04;
    #     background: @base01;
    #   }

    #   /*window#waybar {
    #       background-color: rgba(0,0,0,0);
    #   }

    #   window#waybar.hidden {
    #       opacity: 0.2;
    #   }*/

    #   #workspaces {
    #     margin: 0 4px;
    #   }

    #   #workspaces button {
    #     margin: 4px 0;
    #     padding: 0 6px;
    #     color: @base05;
    #   }

    #   #workspaces button.visible {
    #   }

    #   #workspaces button.focused {
    #     border-radius: 4px;
    #     background-color: @base02;
    #   }

    #   #workspaces button.urgent {
    #     color: rgba(238, 46, 36, 1);
    #   }

    #   #tray {
    #     margin: 4px 16px 4px 4px;
    #     border-radius: 4px;
    #     background-color: @base02;
    #   }

    #   #tray * {
    #     padding: 0 6px;
    #     border-left: 1px solid @base00;
    #   }

    #   #tray *:first-child {
    #     border-left: none;
    #   }

    #   #mode, #battery, #cpu, #memory, #network, #pulseaudio, #idle_inhibitor, #backlight, #custom-storage, #custom-spotify, #custom-weather, #custom-mail, #clock, #temperature {
    #     margin: 4px 2px;
    #     padding: 0 6px;
    #     background-color: @base02;
    #     border-radius: 4px;
    #     min-width: 20px;
    #   }

    #   #pulseaudio.muted {
    #     color: @base0F;
    #   }

    #   #pulseaudio.bluetooth {
    #     color: @base0C;
    #   }

    #   #clock {
    #     margin-left: 12px;
    #     margin-right: 4px;
    #     background-color: transparent;
    #   }

    #   #temperature.critical {
    #     color: @base0F;
    #   }
    # '';

    settings = [
      {
        height = 40;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ ];
        modules-right = [
          "pulseaudio"
          "network"
          "memory"
          "temperature"
          "cpu"
          "battery"
          "clock"
          "tray"
        ];

        modules = {
          "sway/workspaces" = {
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
              "7" = "";
              "9" = "";
              "10" = "";
              focused = "";
              urgent = "";
              default = "";
            };
          };
          tray = {
            spacing = 10;
          };
          clock = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%A, %d %b}";
          };
          cpu = {
            format = "{usage}% ";
          };
          memory = {
            format = "{}% ";
          };
          backlight = {
            format = "{icon}";
            format-alt = "{percent}% {icon}";
            format-alt-click = "click-right";
            format-icons = [ "○" "◐" "●" ];
            on-scroll-down = "light -U 10";
            on-scroll-up = "light -A 10";
          };
          # "battery#bat0" = battery { name = "BAT0"; };
          # "battery#bat1" = battery { name = "BAT1"; };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "Ethernet ";
            format-linked = "Ethernet (No IP) ";
            format-disconnected = "Disconnected ";
            format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
            on-click-middle = "nm-connection-editor";
          };
          # pulseaudio = mkIf audioSupport {
          #   scroll-step = 1;
          #   format = "{volume}% {icon} {format_source}";
          #   format-bluetooth = "{volume}% {icon} {format_source}";
          #   format-bluetooth-muted = " {icon} {format_source}";
          #   format-muted = " {format_source}";
          #   format-source = "{volume}% ";
          #   format-source-muted = "";
          #   format-icons = {
          #       headphone = "";
          #       hands-free = "";
          #       headset = "";
          #       phone = "";
          #       portable = "";
          #       car = "";
          #       default = [ "" "" "" ];
          #   };
          #   on-click = "pavucontrol";
          # };
          # "custom/media#0" = mkIf audioSupport (media { number = 0; });
          # "custom/media#1" = mkIf audioSupport (media { number = 1; });
          # "custom/power" = {
          #   format = "";
          #   on-click = "nwgbar -o 0.2";
          #   escape = true;
          #   tooltip = false;
          # };
        };
      }
    ];


    style = ''
       * {
           border: none;
           border-radius: 0;
           /*font-family: "SF Pro Display", "Font Awesome 5 Free";*/
           font-size: 13px;
       }

       window#waybar {
           background-color: rgba(0,0,0,0);
       }

       window#waybar.hidden {
           opacity: 0.2;
       }

       #waybar > .horizontal {
           padding: 10px 10px 0;
       }

       #waybar > .horizontal > .horizontal:nth-child(1) {
           margin-right: 10px;
       }

       #workspaces button {
       	margin: 10px 0 0 10px;
       	font-size: 16px;
       	/*padding: 7px 10px;*/
         padding: 5px 10px;
       	border-radius: 5px;
       }

      #workspaces button label {
           font-size: 28px;
       }

       #workspaces button:hover {
           box-shadow: inherit;
           text-shadow: inherit;
       }

       #mode {
       	margin: 10px 0 0 10px;
       	padding: 0 10px;
       	border-radius: 5px;
       }

       #window {
           font-weight: 600;
       	margin: 10px 0 0 10px;
       }

       #tray,
       #pulseaudio,
       #network,
       #memory,
       #cpu,
       #backlight,
       #battery,
       #clock,
       #custom-media,
       #custom-power {
       	margin: 10px 10px 0 0;
       	padding: 7px 15px;
         border-radius: 5px;
       }

       #backlight {
           font-size: 15px;
       }
       #custom-media {
           min-width: 100px;
           margin: 10px 0 0 10px;
       }

       #custom-media:nth-child(2) {
           margin-right: 10px;
       }

       /* Colors */
       /* Base */
       #workspaces button,
       #mode,
       #tray,
       #pulseaudio,
       #network,
       #memory,
       #cpu,
       #backlight,
       #battery,
       #clock,
       #custom-media,
       #custom-power {
           /*background: ${rgbaColor colors.gray._200 90};*/
           background: rgba(74,85,104,0.6);
           /*color: ${hexColor colors.gray._700};*/
           color: #ffffff;
       }
       /* Effects */
       #workspaces button:hover {
           /*background: ${rgbaColor colors.gray._200 40};*/
           background: rgba(74,85,104,0.2);
           box-shadow: inherit;
           text-shadow: inherit;
       }
       #workspaces button.focused {
           /*background: ${rgbaColor colors.gray._300 100};
           color: ${hexColor colors.gray._800};*/
           background-color: #2D3748;
       }
       /* Disabled */
       #network.disconnected,
       #pulseaudio.muted,
       #custom-nordvpn.disconnected {
           background: ${rgbaColor colors.gray._200 50};
           color: ${hexColor colors.gray._400};
       }
       /* Green */
       #battery.charging {
           background: ${rgbaColor colors.green._200 60};
           color: ${hexColor colors.green._900};
       }
       /* Urgent */
       #workspaces button.urgent,
       #battery.critical:not(.charging) {
           background: ${rgbaColor colors.red._200 90};
           color: ${hexColor colors.red._900};
       }
       /* Tooltip */
       tooltip {
           background: ${rgbaColor colors.gray._200 90};
           box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
       }

       tooltip * {
           color: ${hexColor colors.gray._700};
       }
    '';
  };

  services.dunst = {
    enable = true;
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
