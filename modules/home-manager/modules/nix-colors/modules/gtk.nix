{ config, lib, pkgs, inputs, ... }:

with lib;

let
  inherit (inputs.nix-colors.lib { inherit pkgs; }) gtkThemeFromScheme;
  csTypes = import ../types.nix { inherit config lib; };

  cfg = config.gtk;
  colorscheme = cfg.nix-colors.colorscheme;
in
{
  options = {
    gtk.nix-colors = mkOption {
      type = csTypes.nix-colors;
      default = { };
    };
  };

  config = mkIf cfg.nix-colors.enable {
    gtk.theme = {
      name = "${colorscheme.slug}";
      package = gtkThemeFromScheme { scheme = colorscheme; };
    };
  };
}
