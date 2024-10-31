{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    iosevka
    jetbrains-mono
    merriweather
    merriweather-sans
    roboto
    roboto-slab
    roboto-mono
    montserrat
    lato

    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })

    font-awesome
    font-awesome_5

    pkgs.nur.repos.sagikazarmark.sf-pro
    clarity-city
  ];
}
