{ config, pkgs, lib, inputs, ... }:

let
  colorschemes = inputs.nix-colors.colorSchemes;
in
{
  colorscheme = colorschemes.tokyo-night-storm;

  programs.kitty.nix-colors = {
    enable = true;
    colorscheme = lib.recursiveUpdate colorschemes.tokyo-night-terminal-storm {
      palette = {
        base05 = "A9B1D6";
      };
    };
  };

  programs.fzf.nix-colors.enable = true;

  # gtk.nix-colors.enable = true;

  wayland.windowManager.sway.nix-colors.enable = true;

  programs.waybar.nix-colors.enable = true;

  programs.rofi.nix-colors.enable = true;

  services.dunst.nix-colors.enable = true;
  services.dunst.nix-colors.colorscheme = colorschemes.twilight;
}
