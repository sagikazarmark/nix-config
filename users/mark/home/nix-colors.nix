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

  # this is required otherwise colorscheme is messed up
  programs.fzf.nix-colors.colorscheme = colorschemes.tokyo-night-storm;

  # gtk.nix-colors.enable = true;

  wayland.windowManager.sway.nix-colors.enable = true;

  programs.waybar.nix-colors.enable = true;

  programs.rofi.nix-colors.enable = true;

  services.dunst.nix-colors.enable = true;
  services.dunst.nix-colors.colorscheme = colorschemes.twilight;
}
