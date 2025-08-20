{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    SOPS_AGE_KEY_CMD = "op item get vxhe5lpngghsftv46zlhf76clm --fields label=password --reveal";
  };

  home.shell = {
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

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

    btop
    duf
    freshfetch
    fd
    du-dust
    sd
    hyperfine
    # ytop
    tealdeer
    bandwhich
    grex
    zoxide
    tre
    hishtory
    # delta

    zstd

    # Deprecated
    # youtube-dl
    yt-dlp

    asciinema
    vhs

    # Work with webp images
    libwebp

    ranger
    nnn

    cmatrix

    swaks

    iperf
    dnsperf

    todoist

    # git stuff
    # serie
    # https://github.com/NixOS/nixpkgs/pull/435013
    # (serie.overrideAttrs (oldAttrs: {
    #   version = "0.4.6";
    #   src = oldAttrs.src.overrideAttrs (oldAttrs: {
    #     hash = "sha256-26B/bwXz60fcZrh6H1RPROiML44S1Pt1J3VrJh2gRrI=";
    #   });
    #   cargoHash = "sha256-Bdk553tECJiMxJlXj147Sv2LzH+nM+/Cm5BpBr78I4o=";
    # }))
    diffnav

    ## Neovim
    # Lunarvim requires fd and ripgrep as well.
    neovim
    # (wrapNeovim neovim-unwrapped {
    #   extraMakeWrapperArgs = ''--prefix PATH : "${
    #     lib.makeBinPath [
    #       ripgrep
    #       fd
    #       fzf
    #     ]
    #   }"'';
    # })
    # nodePackages.neovim
    neovim-node-client
    python312Packages.pynvim
    tree-sitter

    woff2

    gimp

  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.pub-cache/bin"
  ];

  programs.bat = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;

    arguments = [
      "--glob=!.direnv/"
      "--glob=!.devenv/"
    ];
  };

  programs.lsd = {
    enable = true;

    settings = {
      icons.separator = "  ";
    };
  };

  programs.jq.enable = true;
  programs.gron = {
    enable = true;
    enableShellAliases = true;
  };
  programs.htop.enable = true;
  programs.command-not-found.enable = true;

  programs.fzf = {
    enable = true;

    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    history.path = "${config.xdg.dataHome}/zsh/history";

    localVariables = {
      LESSHISTFILE = "/dev/null";

      # TODO: ZSH login shells probably need a different browser (qutebrowser?)
      BROWSER = if pkgs.stdenv.isDarwin then "open" else "firefox";

      GREP_OPTIONS = "--exclude-dir=.devenv";
    };
    initContent =
      let
        # p10k Home manager config: https://github.com/nix-community/home-manager/issues/1338#issuecomment-651807792
        initBeforeCompletion = lib.mkOrder 550 ''
          # p10k instant prompt
          local P10K_INSTANT_PROMPT="${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
          [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"

          # Custom completions
          # TODO: get rid of it?
          fpath+=("$XDG_DATA_HOME/zsh/completions")
        '';

        init = lib.mkOrder 1000 ''
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
          # Not necessary anymore
          # unalias duf
        '';
      in
      lib.mkMerge [
        initBeforeCompletion
        init
      ];

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

    profileExtra =
      ''
        # Preferred editor for local and remote sessions
        # TODO: test that it works properly for SSH login shells.
        if [ -n $SSH_CONNECTION ]; then
            export EDITOR='nvim'
            export GUIEDITOR='nvim'
        else
            export EDITOR='nvim'
            export GUIEDITOR='code'
        fi
      ''
      + lib.optionalString (config.home.sessionPath != [ ]) ''
        export PATH="$PATH''${PATH:+:}${lib.concatStringsSep ":" config.home.sessionPath}"
      '';

    oh-my-zsh = {
      enable = true;

      plugins = [
        "common-aliases"
        "sudo"
      ];
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
      vim = "nvim";

      # Find my IP address
      myip = "dig +short myip.opendns.com @resolver1.opendns.com";

      sudoedit = "sudo $EDITOR";

      pu = "ps aux | grep -v grep | grep";

      rs = "exec $SHELL";

      favico = "convert -resize x32 -gravity center -crop 32x32+0+0 -flatten -colors 256 -background transparent";

      icat = "kitty +kitten icat";
    };
  };

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;

    nix-direnv = {
      enable = true;
    };
  };

  xdg.enable = true;
  # xdg.userDirs.enable = true; # Not supported on darwin
  xdg.configFile = {
    # Not supported on darwin
    /*
      # Required for user dirs
      "user-dirs.locale" = {
      text = "en_US";
      };
    */

    # "asdf/tool-versions" = {
    #   source = ./dotfiles/asdf/tool-versions;
    #   /* recursive = true; */
    # };

    "lvim/config.lua" = {
      source = ./dotfiles/lvim/config.lua;
    };

    "wgetrc" = {
      text = ''
        hsts-file = ${config.xdg.cacheHome}/wget-hsts
      '';
    };
  };

  xdg.dataFile = {
    sounds = {
      source = ./dotfiles/sounds;
      recursive = true;
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
