{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # ZSH packages
    zsh-powerlevel10k

    coreutils
    gnused
    wget
    neofetch
    stow
    tree
    # mkpasswd
    entr

    yq-go

    duf
    freshfetch
    fd
    ripgrep
    du-dust
    sd
    hyperfine
    # ytop
    tealdeer
    bandwhich
    grex
    zoxide
    # delta

    zstd

    youtube-dl
    asciinema

    ranger
    nnn

    cmatrix

    swaks

    iperf
    dnsperf

    todoist

    ## Neovim
    # Lunarvim requires fd and ripgrep as well.
    neovim
    nodePackages.neovim
    python39Packages.pynvim
    tree-sitter
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  colorscheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

  programs.bat = {
    enable = true;
  };

  programs.lsd = {
    enable = true;

    enableAliases = true;
    settings = {
      icons.separator = "  ";
    };
  };

  programs.jq.enable = true;
  programs.htop.enable = true;
  programs.command-not-found.enable = true;

  programs.fzf = {
    enable = true;

    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    history.path = "${config.xdg.dataHome}/zsh/history";

    # p10k Home manager config: https://github.com/nix-community/home-manager/issues/1338#issuecomment-651807792
    initExtraBeforeCompInit = ''
      # p10k instant prompt
      local P10K_INSTANT_PROMPT="${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"

      # Custom completions
      # TODO: get rid of it?
      fpath+=("$XDG_DATA_HOME/zsh/completions")
    '';

    plugins = [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        file = "p10k.zsh";
        name = "powerlevel10k-config";
        src = ./dotfiles/zsh;
      }

      # TODO: find a better way to load custom functions (eg. read file? custom ZSH source load?)
      {
        file = "func.zsh";
        name = "func";
        src = ./dotfiles/zsh;
      }
    ];

    localVariables = {
      LESSHISTFILE = "/dev/null";
    };

    initExtra = ''
      # Powerlevel10k config
      typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=
      typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

      if [[ -f $XDG_DATA_HOME/zsh/zshrc ]]; then source $XDG_DATA_HOME/zsh/zshrc; fi


      # Use vim keys in tab complete menu:
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history


      # Unset 'duf' alias set by ohmyzsh in OMZ::plugins/common-aliases/common-aliases.plugin.zsh
      unalias duf
    '';

    zprofileExtra = ''
      # Preferred editor for local and remote sessions
      # TODO: test that it works properly for SSH login shells.
      if [ -n $SSH_CONNECTION ]; then
          export EDITOR='lvim'
          export GUIEDITOR='lvim'
      else
          export EDITOR='lvim'
          export GUIEDITOR='code'
      fi

      # TODO: ZSH login shells probably need a different browser (qutebrowser?)
      export BROWSER=firefox-developer-edition
    '';

    oh-my-zsh = {
      enable = true;

      plugins = [ "common-aliases" "sudo" ];
    };

    shellAliases = {
      # Basic file aliases
      # managed by programs.lsd
      # ls = "lsd";
      # ll = "ls -halF";
      # la = "ls -A";
      # l = "ls -CF";
      rmdot = "rm -rf .[!.]*";

      hm = "home-manager";
      vim = "lvim";

      # Find my IP address
      myip = "dig +short myip.opendns.com @resolver1.opendns.com";

      sudoedit = "sudo $EDITOR";

      pu = "ps aux | grep -v grep | grep";

      rs = "exec $SHELL";

      # Gron aliases
      norg = "gron --ungrong";
      ungron = "gron --ungron";

      favico = "convert -resize x32 -gravity center -crop 32x32+0+0 -flatten -colors 256 -background transparent";

      icat = "kitty +kitten icat";
    };
  };

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;

    nix-direnv = {
      enable = true;

      # No longer necessary
      # enableFlakes = true;
    };
  };

  xdg.enable = true;
  # xdg.userDirs.enable = true; # Not supported on darwin
  xdg.configFile = {
    # Not supported on darwin
    /* # Required for user dirs
      "user-dirs.locale" = {
      text = "en_US";
      }; */

    # "asdf/tool-versions" = {
    #   source = ./dotfiles/asdf/tool-versions;
    #   /* recursive = true; */
    # };

    "wgetrc" = {
      text = ''
        hsts-file = ${config.xdg.cacheHome}/wget-hsts
      '';
    };
  };

  xdg.fallback.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "21.11";
}
