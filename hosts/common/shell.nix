{ ... }:

{
  # Required for users with ZSH as the default shell
  #
  # Required for home-manager ZSH module
  # https://github.com/nix-community/home-manager/issues/2991
  programs.zsh = {
    enable = true;
  };
}
