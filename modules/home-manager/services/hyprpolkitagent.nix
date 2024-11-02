{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.hyprpolkitagent;
in
{
  options.services.hyprpolkitagent = {
    enable = mkEnableOption "A simple polkit authentication agent for Hyprland, written in QT/QML";

    package = mkPackageOption pkgs "hyprpolkitagent" { };
  };

  config = mkIf cfg.enable {
    # Based on https://github.com/hyprwm/hyprpolkitagent/blob/615efd49303cb164bbf4ad065792e02d8f652a36/assets/hyprpolkitagent-service.in
    systemd.user.services.hyprpolkitagent = {
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "Hyprland Polkit Authentication Agent";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/libexec/hyprpolkitagent";
        Slice = "session.slice";
        TimeoutStopSec = "5sec";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
