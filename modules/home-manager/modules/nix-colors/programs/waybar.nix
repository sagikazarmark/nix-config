{ config, lib, ... }:

with lib;

let
  csTypes = import ../types.nix { inherit config lib; };

  cfg = config.programs.waybar;
  colorscheme = cfg.nix-colors.colorscheme;
in
{
  options = {
    programs.waybar.nix-colors = mkOption {
      type = csTypes.nix-colors;
      default = { };
    };
  };

  config = mkIf cfg.nix-colors.enable {
    programs.waybar.style = mkDefault ''
      @import "colors/base16-${colorscheme.slug}.css";
    '';

    xdg.configFile = {
      # https://github.com/mnussbaum/base16-waybar
      "waybar/colors/base16-${colorscheme.slug}.css" = {
        text = ''
          /*
          *
          * Base16 ${colorscheme.name}
          * Author: ${colorscheme.author}
          *
          */

          @define-color base00 #${ colorscheme.colors.base00 };
          @define-color base01 #${ colorscheme.colors.base01 };
          @define-color base02 #${ colorscheme.colors.base02 };
          @define-color base03 #${ colorscheme.colors.base03 };
          @define-color base04 #${ colorscheme.colors.base04 };
          @define-color base05 #${ colorscheme.colors.base05 };
          @define-color base06 #${ colorscheme.colors.base06 };
          @define-color base07 #${ colorscheme.colors.base07 };
          @define-color base08 #${ colorscheme.colors.base08 };
          @define-color base09 #${ colorscheme.colors.base09 };
          @define-color base0A #${ colorscheme.colors.base0A };
          @define-color base0B #${ colorscheme.colors.base0B };
          @define-color base0C #${ colorscheme.colors.base0C };
          @define-color base0D #${ colorscheme.colors.base0D };
          @define-color base0E #${ colorscheme.colors.base0E };
          @define-color base0F #${ colorscheme.colors.base0F };
        '';
      };
    };
  };
}
