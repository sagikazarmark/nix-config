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

  # This only works on macOS
  home.file.".terminfo/67/ghostty".source = "${config.programs.ghostty.package}/Applications/Ghostty.app/Contents/Resources/terminfo/67/ghostty";
  home.file.".terminfo/78/ghostty".source = "${config.programs.ghostty.package}/Applications/Ghostty.app/Contents/Resources/terminfo/78/xterm-ghostty";
}
