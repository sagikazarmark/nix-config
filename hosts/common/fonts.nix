{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    iosevka
    jetbrains-mono

    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })

    font-awesome
    font-awesome_5
    pkgs.nur.repos.sagikazarmark.sf-pro
  ];
}
