{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.gron;

  aliases = {
    norg = "gron --ungron";
    ungron = "gron --ungron";
    ugron = "gron --ungron";
  };
in
{
  options.programs.gron = {
    enable = mkEnableOption "gron - Make JSON greppable!";

    package = mkOption {
      type = types.package;
      default = pkgs.gron;
      defaultText = literalExpression "pkgs.gron";
      description = "Package providing the <command>gron</command> tool.";
    };

    enableShellAliases = mkEnableOption "enable recommended gron shell aliases";
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.bash.shellAliases = mkIf cfg.enableShellAliases aliases;

    programs.zsh.shellAliases = mkIf cfg.enableShellAliases aliases;

    programs.fish.shellAliases = mkIf cfg.enableShellAliases aliases;
  };
}
