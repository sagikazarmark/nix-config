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
    ./shell.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git

    pciutils
    usbutils
  ];
}
