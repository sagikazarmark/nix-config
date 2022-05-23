{ pkgs, ... }:

{
  # home.packages = [
  #   pkgs.whitesur-gtk-theme
  #   pkgs.whitesur-icon-theme
  # ];

  gtk.theme = {
    name = "WhiteSur-dark";
    package = pkgs.whitesur-gtk-theme;
  };
}
