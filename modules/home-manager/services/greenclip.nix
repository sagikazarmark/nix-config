{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.greenclip;
in
{
  options = {
    services.greenclip = {
      enable = mkEnableOption "Greenclip daemon";

      package = mkOption {
        type = types.package;
        default = pkgs.haskellPackages.greenclip;
        defaultText = literalExpression "pkgs.haskellPackages.greenclip";
        description = "Package providing the greenclip daemon.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.greenclip = {
      Unit = {
        Description = "Greenclip daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/greenclip daemon";
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };
}
