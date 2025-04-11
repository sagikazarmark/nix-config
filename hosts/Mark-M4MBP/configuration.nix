{ ... }:

{
  imports = [
    ../common/darwin/shell.nix
    ../common/darwin/nix.nix
    ../common/darwin/security.nix
    ../common/darwin/settings.nix
    ../common/darwin/wm.nix
    ../common/darwin/homebrew.nix

    # This messes with existing keyboard selection
    # TODO: move this to an initial setup
    # ../common/darwin/keyboard
  ];
}
