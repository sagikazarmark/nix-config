{ config, lib, pkgs, ... }:

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

  config = mkIf cfg.enable (mkMerge [
    { }
  ]);
}
