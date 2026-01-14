{ pkgs, config, ... }:

{
  programs.zellij = {
    enable = true;

    # installBatSyntax = true;
    # enableBashIntegration = true;
    # enableZshIntegration = true;
  };

  catppuccin.zellij.enable = true;
}
