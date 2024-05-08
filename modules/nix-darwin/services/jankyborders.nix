{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jankyborders;
in
{
  options.services.jankyborders = {
    enable = mkEnableOption "JankyBorders is a lightweight tool designed to add colored borders to user windows on macOS 14.0+";

    package = mkOption {
      type = types.package;
      default = pkgs.jankyborders;
      defaultText = literalExpression "pkgs.jankyborders";
      description = "Package providing the <command>borders</command> tool.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.borders = {
      serviceConfig.ProgramArguments = [ "${cfg.package}/bin/borders" ];
      serviceConfig.KeepAlive = true;
      serviceConfig.RunAtLoad = true;
      serviceConfig.ProcessType = "Interactive";
      serviceConfig.EnvironmentVariables = {
        PATH = "${cfg.package}/bin:${config.environment.systemPath}";
      };
    };
  };
}
