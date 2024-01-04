{ pkgs, ... }:

{

  imports = [
    ./defaults.nix
    ./i18n.nix
    ./networking.nix
    ./nix.nix
    ./users.nix
    ./security.nix
    ./audio.nix
    ./fonts.nix

    # ./logitech.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git

    pciutils
    usbutils
  ];

  # Required for the user to show up in GNOME
  # https://www.reddit.com/r/NixOS/comments/ocimef/users_not_showing_up_in_gnome/
  environment.shells = [ pkgs.zsh ];

  # Required for home-manager ZSH module
  # https://github.com/nix-community/home-manager/issues/2991
  programs.zsh = {
    enable = true;
  };
}
