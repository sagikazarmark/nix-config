{ pkgs, config, ... }:

{
  programs.ghostty = {
    enable = true;

    # TODO: make this cross-compatible with Linux
    # TODO: use ghostty-bin to install ghostty
    package = pkgs.ghostty-bin;

    # installBatSyntax = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      theme = "Catppuccin Mocha";

      keybind = [
        "global:super+alt+enter=new_window"
      ];
    };
  };

  catppuccin.ghostty.enable = true;
}
