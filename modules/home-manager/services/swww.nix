{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.swww;
in
{
  options.services.swww = {
    enable = mkEnableOption "A Solution to your Wayland Wallpaper Woes";

    package = mkPackageOption pkgs "swww" { };

    # TODO: add daemon opts: format, no-cache
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.swww = {
      Install = { WantedBy = [ "graphical-session.target" ]; };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "swww";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/swww-daemon";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
