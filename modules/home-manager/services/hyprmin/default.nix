{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hyprmin;
in
{
  options.services.hyprmin = {
    enable = mkEnableOption "Hyprland hook to minimize all windows when a new one is opened";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.socat ];

    systemd.user.services.hyprmin = {
      Install = { WantedBy = [ "graphical-session.target" ]; };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hyprmin";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = ./hook.sh;
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
