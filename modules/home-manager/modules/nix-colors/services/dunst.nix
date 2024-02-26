{ config, lib, ... }:

with lib;

let
  csTypes = import ../types.nix { inherit config lib; };

  cfg = config.services.dunst;
  colorscheme = cfg.nix-colors.colorscheme;
in
{
  options = {
    services.dunst.nix-colors = mkOption {
      type = csTypes.nix-colors;
      default = { };
    };
  };

  config = mkIf cfg.nix-colors.enable {
    # https://github.com/khamer/base16-dunst
    services.dunst.settings = {
      global = {
        frame_color = "#${ colorscheme.palette.base05 }";
        separator_color = "#${ colorscheme.palette.base05 }";
      };

      base16_low = {
        msg_urgency = "low";
        background = "#${ colorscheme.palette.base01 }";
        foreground = "#${ colorscheme.palette.base03 }";
      };

      base16_normal = {
        msg_urgency = "normal";
        background = "#${ colorscheme.palette.base02 }";
        foreground = "#${ colorscheme.palette.base05 }";
      };

      base16_critical = {
        msg_urgency = "critical";
        background = "#${ colorscheme.palette.base08 }";
        foreground = "#${ colorscheme.palette.base06 }";
      };
    };
  };
}
