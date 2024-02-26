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

          @define-color base00 #${ colorscheme.palette.base00 };
          @define-color base01 #${ colorscheme.palette.base01 };
          @define-color base02 #${ colorscheme.palette.base02 };
          @define-color base03 #${ colorscheme.palette.base03 };
          @define-color base04 #${ colorscheme.palette.base04 };
          @define-color base05 #${ colorscheme.palette.base05 };
          @define-color base06 #${ colorscheme.palette.base06 };
          @define-color base07 #${ colorscheme.palette.base07 };
          @define-color base08 #${ colorscheme.palette.base08 };
          @define-color base09 #${ colorscheme.palette.base09 };
          @define-color base0A #${ colorscheme.palette.base0A };
          @define-color base0B #${ colorscheme.palette.base0B };
          @define-color base0C #${ colorscheme.palette.base0C };
          @define-color base0D #${ colorscheme.palette.base0D };
          @define-color base0E #${ colorscheme.palette.base0E };
          @define-color base0F #${ colorscheme.palette.base0F };
        '';
      };
    };
  };
}
