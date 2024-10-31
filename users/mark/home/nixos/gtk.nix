{ pkgs, ... }:

{
  # home.packages = [
  #   pkgs.whitesur-gtk-theme
  #   pkgs.whitesur-icon-theme
  # ];

  gtk = {
    enable = true;

    theme = {
      name = "WhiteSur-dark";
      package = (pkgs.whitesur-gtk-theme.override {
        altVariants = [ "all" ];
        themeVariants = [ "all" ];
      });
    };

    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;

      # name = "Papirus-Dark";
      # package = pkgs.papirus-icon-theme;
    };

    # cursorTheme = pkgs.numix-cursor-theme;
  };
}
