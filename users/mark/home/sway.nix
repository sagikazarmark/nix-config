{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${config.programs.rofi.package}/bin/rofi";

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
          cfg = config.wayland.windowManager.sway;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${cfg.config.terminal}";
          # "''${modifier}+Shift+q" = "kill";
          "${modifier}+Space" = "exec ${cfg.config.menu}";
        };
    };

    extraOptions = [ "--unsupported-gpu" ];
    # ++ lib.optionals (lib.elem "nvidia" sysconfig.services.xserver.videoDrivers) [ "--unsupported-gpu" ];
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    terminal = "${pkgs.kitty}/bin/kitty";
  };
}
