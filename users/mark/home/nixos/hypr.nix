{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      enable = true;
      enableXdgAutostart = true;

      variables = [ "--all" ];
    };

    xwayland.enable = true;

    settings = { };

    # TODO: move to settings?
    extraConfig = (builtins.readFile ../../../../dotfiles/hypr/hyprland.conf);
  };

  services.hypridle = {
    enable = true;

    settings = {
      # https://github.com/nix-community/home-manager/issues/5899#issuecomment-2449422218
      general = {
        # avoid starting multiple hyprlock instances.
        lock_cmd = "${pkgs.procps}/bin/pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        unlock_cmd = "pkill - USR1 ${pkgs.hyprlock}/bin/hyprlock";

        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };
    };

    # TODO: move to settings?
    extraConfig = (builtins.readFile ../../../../dotfiles/hypr/hypridle.conf);
  };

  programs.hyprlock = {
    enable = true;

    settings = { };

    # TODO: move to settings?
    extraConfig = (builtins.readFile ../../../../dotfiles/hypr/hyprlock.conf);
  };

  services.swww = {
    enable = true;
  };

  services.hyprmin.enable = true;

  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };

    settings = {
      mainBar = {
        height = 40;
        modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
        modules-center = [ ];
        modules-right = [
          "pulseaudio"
          "idle_inhibitor"
          "network"
          "temperature"
          "memory"
          "cpu"
          "battery"
          "clock"
          "tray"
        ];

        # backlight = {
        #   format = "{icon}";
        #   format-alt = "{percent}% {icon}";
        #   format-alt-click = "click-right";
        #   format-icons = [ "○" "◐" "●" ];
        #   on-scroll-down = "light -U 10";
        #   on-scroll-up = "light -A 10";
        # };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%A, %d %b}";
        };
        cpu = {
          format = "{usage}% ";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        memory = {
          format = "{}% ";
          format-alt = "{used:0.1f}G/{total:0.1f}G ";
        };
        network = {
          format = "{ifname}";
          format-alt = "⬇️ {bandwidthDownBits} / ⬆️ {bandwidthUpBits}";
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-linked = "no ip ";
          format-disconnected = "Disconnected ";
          tooltip-format = "{ifname} via {gwaddr} ";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";

          on-click-middle = "nm-connection-editor";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };
        temperature = {
          format = "{temperatureC}°C ";
        };
        tray = {
          spacing = 10;
        };
        "hyprland/workspaces" = {
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
        # "custom/media#0" = mkIf audioSupport (media { number = 0; });
        # "custom/media#1" = mkIf audioSupport (media { number = 1; });
        # "custom/power" = {
        #   format = "";
        #   on-click = "nwgbar -o 0.2";
        #   escape = true;
        #   tooltip = false;
        # };
      };
    };


    style = builtins.readFile ../../../../dotfiles/waybar/styles/desert.css;
  };
}
