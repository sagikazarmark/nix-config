{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asdf-vm;
in
{
  options.programs.asdf-vm = {
    enable = mkEnableOption "asdf-vm - extendable version manager";

    package = mkOption {
      type = types.package;
      default = pkgs.asdf-vm;
      defaultText = literalExpression "pkgs.asdf-vm";
      description = "Package providing the <command>asdf</command> tool.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.sessionVariables = {
      ASDF_CONFIG_FILE = "${config.xdg.configHome}/asdf/asdfrc";
      ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
      # ASDF_DEFAULT_TOOL_VERSIONS_FILENAME = "${config.xdg.configHome}/asdf/tool-versions";
    };

    home.sessionPath = [
      "$ASDF_DIR/asdf.sh"
    ];
  };
}
