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
        border = "${colorscheme.colors.base05}";
        background = "${colorscheme.colors.base0D}";
        text = "${colorscheme.colors.base00}";
        indicator = "${colorscheme.colors.base0D}";
        childBorder = "${colorscheme.colors.base0D}";
      };

      focusedInactive = {
        border = "${colorscheme.colors.base01}";
        background = "${colorscheme.colors.base01}";
        text = "${colorscheme.colors.base05}";
        indicator = "${colorscheme.colors.base03}";
        childBorder = "${colorscheme.colors.base01}";
      };

      unfocused = {
        border = "${colorscheme.colors.base01}";
        background = "${colorscheme.colors.base00}";
        text = "${colorscheme.colors.base05}";
        indicator = "${colorscheme.colors.base01}";
        childBorder = "${colorscheme.colors.base01}";
      };

      urgent = {
        border = "${colorscheme.colors.base08}";
        background = "${colorscheme.colors.base08}";
        text = "${colorscheme.colors.base00}";
        indicator = "${colorscheme.colors.base08}";
        childBorder = "${colorscheme.colors.base08}";
      };

      placeholder = {
        border = "${colorscheme.colors.base00}";
        background = "${colorscheme.colors.base00}";
        text = "${colorscheme.colors.base05}";
        indicator = "${colorscheme.colors.base00}";
        childBorder = "${colorscheme.colors.base00}";
      };

      background = "${colorscheme.colors.base07}";
    };

    # wayland.windowManager.sway.config.colors = {
    #   focused = {
    #     border = "${colorscheme.colors.base0C}";
    #     background = "${colorscheme.colors.base00}";
    #     text = "${colorscheme.colors.base05}";
    #     indicator = "${colorscheme.colors.base09}";
    #     childBorder = "${colorscheme.colors.base0C}";
    #   };

    #   focusedInactive = {
    #     border = "${colorscheme.colors.base03}";
    #     background = "${colorscheme.colors.base00}";
    #     text = "${colorscheme.colors.base04}";
    #     indicator = "${colorscheme.colors.base03}";
    #     childBorder = "${colorscheme.colors.base03}";
    #   };

    #   unfocused = {
    #     border = "${colorscheme.colors.base02}";
    #     background = "${colorscheme.colors.base00}";
    #     text = "${colorscheme.colors.base03}";
    #     indicator = "${colorscheme.colors.base02}";
    #     childBorder = "${colorscheme.colors.base02}";
    #   };

    #   urgent = {
    #     border = "${colorscheme.colors.base09}";
    #     background = "${colorscheme.colors.base00}";
    #     text = "${colorscheme.colors.base03}";
    #     indicator = "${colorscheme.colors.base09}";
    #     childBorder = "${colorscheme.colors.base09}";
    #   };
    # };

    # https://aflab.fr/blog/my-custom-tilling-windows-manager-with-a-uniform-look/#sway
    # wayland.windowManager.sway.config.colors = {
    #   focused = {
    #     border = "${colorscheme.colors.base00}";
    #     background = "${colorscheme.colors.base02}";
    #     text = "${colorscheme.colors.base05}";
    #     indicator = "${colorscheme.colors.base0E}";
    #     childBorder = "${colorscheme.colors.base00}";
    #   };

    #   focusedInactive = {
    #     border = "${colorscheme.colors.base00}";
    #     background = "${colorscheme.colors.base01}";
    #     text = "${colorscheme.colors.base05}";
    #     indicator = "${colorscheme.colors.base0E}";
    #     childBorder = "${colorscheme.colors.base00}";
    #   };

    #   unfocused = {
    #     border = "${colorscheme.colors.base00}";
    #     background = "${colorscheme.colors.base01}";
    #     text = "${colorscheme.colors.base05}";
    #     indicator = "${colorscheme.colors.base0E}";
    #     childBorder = "${colorscheme.colors.base00}";
    #   };

    #   urgent = {
    #     border = "${colorscheme.colors.base00}";
    #     background = "${colorscheme.colors.base0D}";
    #     text = "${colorscheme.colors.base05}";
    #     indicator = "${colorscheme.colors.base0E}";
    #     childBorder = "${colorscheme.colors.base00}";
    #   };

    #   placeholder = {
    #     border = "${colorscheme.colors.base00}";
    #     background = "${colorscheme.colors.base00}";
    #     text = "${colorscheme.colors.base05}";
    #     indicator = "${colorscheme.colors.base0E}";
    #     childBorder = "${colorscheme.colors.base00}";
    #   };

    #   background = "${colorscheme.colors.base00}";
    # };
  };
}
