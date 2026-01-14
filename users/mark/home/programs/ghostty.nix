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

      # https://github.com/ghostty-org/ghostty/discussions/3483#discussioncomment-11716750
      macos-option-as-alt = "left";

      keybind = [
        "global:super+alt+enter=new_window"
      ];
    };
  };

  catppuccin.ghostty.enable = true;
}
