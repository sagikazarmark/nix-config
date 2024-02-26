{ config, lib, ... }:

with lib;

let
  csTypes = import ../types.nix { inherit config lib; };

  cfg = config.wayland.windowManager.sway;
  colorscheme = cfg.nix-colors.colorscheme;
in
{
  options = {
    wayland.windowManager.sway.nix-colors = mkOption {
      type = csTypes.nix-colors;
      default = { };
    };
  };

  config = mkIf cfg.nix-colors.enable {
    # https://github.com/rkubosz/base16-sway
    wayland.windowManager.sway.config.colors = {
      focused = {
        border = "${colorscheme.palette.base05}";
        background = "${colorscheme.palette.base0D}";
        text = "${colorscheme.palette.base00}";
        indicator = "${colorscheme.palette.base0D}";
        childBorder = "${colorscheme.palette.base0D}";
      };

      focusedInactive = {
        border = "${colorscheme.palette.base01}";
        background = "${colorscheme.palette.base01}";
        text = "${colorscheme.palette.base05}";
        indicator = "${colorscheme.palette.base03}";
        childBorder = "${colorscheme.palette.base01}";
      };

      unfocused = {
        border = "${colorscheme.palette.base01}";
        background = "${colorscheme.palette.base00}";
        text = "${colorscheme.palette.base05}";
        indicator = "${colorscheme.palette.base01}";
        childBorder = "${colorscheme.palette.base01}";
      };

      urgent = {
        border = "${colorscheme.palette.base08}";
        background = "${colorscheme.palette.base08}";
        text = "${colorscheme.palette.base00}";
        indicator = "${colorscheme.palette.base08}";
        childBorder = "${colorscheme.palette.base08}";
      };

      placeholder = {
        border = "${colorscheme.palette.base00}";
        background = "${colorscheme.palette.base00}";
        text = "${colorscheme.palette.base05}";
        indicator = "${colorscheme.palette.base00}";
        childBorder = "${colorscheme.palette.base00}";
      };

      background = "${colorscheme.palette.base07}";
    };

    # wayland.windowManager.sway.config.colors = {
    #   focused = {
    #     border = "${colorscheme.palette.base0C}";
    #     background = "${colorscheme.palette.base00}";
    #     text = "${colorscheme.palette.base05}";
    #     indicator = "${colorscheme.palette.base09}";
    #     childBorder = "${colorscheme.palette.base0C}";
    #   };

    #   focusedInactive = {
    #     border = "${colorscheme.palette.base03}";
    #     background = "${colorscheme.palette.base00}";
    #     text = "${colorscheme.palette.base04}";
    #     indicator = "${colorscheme.palette.base03}";
    #     childBorder = "${colorscheme.palette.base03}";
    #   };

    #   unfocused = {
    #     border = "${colorscheme.palette.base02}";
    #     background = "${colorscheme.palette.base00}";
    #     text = "${colorscheme.palette.base03}";
    #     indicator = "${colorscheme.palette.base02}";
    #     childBorder = "${colorscheme.palette.base02}";
    #   };

    #   urgent = {
    #     border = "${colorscheme.palette.base09}";
    #     background = "${colorscheme.palette.base00}";
    #     text = "${colorscheme.palette.base03}";
    #     indicator = "${colorscheme.palette.base09}";
    #     childBorder = "${colorscheme.palette.base09}";
    #   };
    # };

    # https://aflab.fr/blog/my-custom-tilling-windows-manager-with-a-uniform-look/#sway
    # wayland.windowManager.sway.config.colors = {
    #   focused = {
    #     border = "${colorscheme.palette.base00}";
    #     background = "${colorscheme.palette.base02}";
    #     text = "${colorscheme.palette.base05}";
    #     indicator = "${colorscheme.palette.base0E}";
    #     childBorder = "${colorscheme.palette.base00}";
    #   };

    #   focusedInactive = {
    #     border = "${colorscheme.palette.base00}";
    #     background = "${colorscheme.palette.base01}";
    #     text = "${colorscheme.palette.base05}";
    #     indicator = "${colorscheme.palette.base0E}";
    #     childBorder = "${colorscheme.palette.base00}";
    #   };

    #   unfocused = {
    #     border = "${colorscheme.palette.base00}";
    #     background = "${colorscheme.palette.base01}";
    #     text = "${colorscheme.palette.base05}";
    #     indicator = "${colorscheme.palette.base0E}";
    #     childBorder = "${colorscheme.palette.base00}";
    #   };

    #   urgent = {
    #     border = "${colorscheme.palette.base00}";
    #     background = "${colorscheme.palette.base0D}";
    #     text = "${colorscheme.palette.base05}";
    #     indicator = "${colorscheme.palette.base0E}";
    #     childBorder = "${colorscheme.palette.base00}";
    #   };

    #   placeholder = {
    #     border = "${colorscheme.palette.base00}";
    #     background = "${colorscheme.palette.base00}";
    #     text = "${colorscheme.palette.base05}";
    #     indicator = "${colorscheme.palette.base0E}";
    #     childBorder = "${colorscheme.palette.base00}";
    #   };

    #   background = "${colorscheme.palette.base00}";
    # };
  };
}
