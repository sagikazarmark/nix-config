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

    # Development

    asdf-vm
    rnix-lsp
    nixfmt
    nixpkgs-fmt
    terraform
    caddy
    cue
    hostctl
    gh
    gron
    k6
    mitmproxy
    mkcert
    nodejs
    protobuf
    tunnelto
    lnav
    nmap
    nixpkgs-review
    vault-bin
    aws-vault

    awscli2
    # azure-cli
    google-cloud-sdk
    scaleway-cli

    ## Neovim
    # Lunarvim requires fd and ripgrep as well.
    neovim
    nodePackages.neovim
    python39Packages.pynvim
    tree-sitter

    ## Go
    # go
    gofumpt

    ## Containers
    lima
    podman
    # podman-compose # Not supported on darwin
    skopeo

    ## Kubernetes
    kubectl
    krew
    kubetail
    kubectx
    kubie
    rakkess
    minikube
    kubernetes-helm
    kind
    kail
    # popeye # Not supported on darwin
    # k3s # Not supported on darwin
    k9s
    skaffold
    stern
    fluxctl
    kustomize
    kubeval
    aws-iam-authenticator
    telepresence2
    argocd
    helm-docs

    nodePackages.snyk

    vagrant
    # openstackclient

    nixos-generators

    # wkhtmltopdf

    firefox-devedition-bin
    _1password-gui
  ];

  home.sessionPath = [
    "$HOME/.local/bin"

    # Go binaries
    "$HOME/.local/share/go/bin"

    # Rust binaries
    "$HOME/.cargo/bin"

    "$XDG_DATA_HOME/npm/bin"

    # Krew binaries
    "\${KREW_ROOT:-$HOME/.krew}/bin"
  ];

  colorscheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

  programs.kitty = {
    enable = true;

    # darwinLaunchOptions = [
    #   "--single-instance"
    #   "--directory=~"
    # ];

    font = {
      name = "Iosevka Nerd Font"; # Previously: JetBrainsMono Nerd Font
      size = 13;
    };

    colorscheme = {
      enable = true;
      override = lib.recursiveUpdate inputs.nix-colors.colorSchemes.tokyo-night-terminal-storm
        {
          colors = {
            base05 = "A9B1D6";
          };
        };
    };

    settings = {
      allow_remote_control = "yes";

      # Darwin (TODO: move this to conditional)
      open_url_modifiers = "cmd"; # TODO: normally this is ctrl
      mac_option_as_alt = "left";

      macos_titlebar_color = "#1f2335";
    };

    keybindings = {
      # Scrolling
      "alt+k" = "scroll_line_up";
      "alt+j" = "scroll_line_down";

      "alt+ctrl+b" = "scroll_page_up";
      "alt+ctrl+f" = "scroll_page_down";

      "alt+g>alt+g" = "scroll_home";
      "alt+shift+g" = "scroll_end";

      # Font size
      "ctrl+." = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+backspace" = "change_font_size all 0";

      # Darwin (TODO: move this to conditional)

      # Required for option (alt) + left/right to jump to next/previous word
      # https://github.com/kovidgoyal/kitty/issues/838#issuecomment-417455803
      "alt+left" = "send_text all \\x1b\\x62";
      "alt+right" = "send_text all \\x1b\\x66";

      # Required for option (alt) + some key combos to work
      # https://github.com/kovidgoyal/kitty/issues/1022#issuecomment-436809049
      # "alt+c" = "send_text all \x1bc";

      "cmd+plus" = "change_font_size all +2.0";
      "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";


      # Unmap

      ## Window management
      "kitty_mod+enter" = "no_op";
      "cmd+enter" = "no_op";

      "kitty_mod+n" = "no_op";
      "cmd+n" = "no_op";

      "kitty_mod+w" = "no_op";
      "kitty_mod+]" = "no_op";
      "kitty_mod+[" = "no_op";
      "kitty_mod+f" = "no_op";
      "kitty_mod+b" = "no_op";
      "kitty_mod+`" = "no_op";
      "kitty_mod+r" = "no_op";
      "kitty_mod+1" = "no_op";
      "kitty_mod+2" = "no_op";
      "kitty_mod+3" = "no_op";
      "kitty_mod+4" = "no_op";
      "kitty_mod+5" = "no_op";
      "kitty_mod+6" = "no_op";
      "kitty_mod+7" = "no_op";
      "kitty_mod+8" = "no_op";
      "kitty_mod+9" = "no_op";
      "kitty_mod+0" = "no_op";

      "cmd+r" = "no_op";

      ## Tab management
      "kitty_mod+right" = "no_op";
      "kitty_mod+left" = "no_op";
      "kitty_mod+t" = "no_op";
      "kitty_mod+q" = "no_op";
      "shift+cmd+w" = "no_op";
      "kitty_mod+." = "no_op";
      "kitty_mod+," = "no_op";
      "kitty_mod+alt+t" = "no_op";

      "shift+cmd+j" = "no_op";
      "cmd+t" = "no_op";
      "cmd+w" = "no_op";
      # "shift+cmd+w" = "no_op";

      ## Layout management
      "kitty_mod+l" = "no_op";
    };
  };

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

  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        commit = {
          signOff = true;
        };
      };
    };
  };

  programs.neomutt = {
    enable = true;

    extraConfig = ''
      # Source: https://github.com/josephholsten/base16-mutt
      # base16-mutt: base16-shell support for mutt
      #
      # These depend on mutt compiled with s-lang, not ncurses. Check by running `mutt -v`
      # Details this configuration may be found in the mutt manual:
      # §3 Patterns <http://www.mutt.org/doc/manual/#patterns>
      # §9 Using color and mono video attributes <http://www.mutt.org/doc/manual/#color>

      # https://www.neomutt.org/guide/configuration.html#color
      # base00 : color00 - Default Background
      # base01 : color18 - Lighter Background (Used for status bars)
      # base02 : color19 - Selection Background
      # base03 : color08 - Comments, Invisibles, Line Highlighting

      # base04 : color20 - Dark Foreground (Used for status bars)
      # base05 : color07 - Default Foreground, Caret, Delimiters, Operators
      # base06 : color21 - Light Foreground (Not often used)
      # base07 : color15 - Light Background (Not often used)

      # base08 : color01 - Index Item: Deleted.
      # base09 : color16 - Message: URL.
      # base0A : color03 - Search Text Background. Message: Bold.
      # base0B : color02 - Message: Code. Index Item: Tagged.
      # base0C : color06 - Message: Subject, Quotes. Index Item: Trusted.
      # base0D : color04 - Message: Headings.
      # base0E : color05 - Message: Italic, Underline. Index Item: Flagged.
      # base0F : color17 - Deprecated, Opening/Closing Embedded Language Tags e.g.

      ## Base
      color normal      color07  color00 # softer, bold

      ## Weak
      color tilde       color08  color00  # `~` padding at the end of pager
      color attachment  color08  color00
      color tree        color08  color00  # arrow in threads
      color signature   color08  color00
      color markers     color08  color00  # `+` wrap indicator in pager

      ## Strong
      color bold        color21  color00
      color underline   color21  color00

      ## Highlight
      color error       color01  color00
      color message     color04  color00  # informational messages
      color search      color08  color03
      color status      color20  color19
      color indicator   color21  color19  # inverse, brighter


      # Message Index ----------------------------------------------------------------

      ## Weak
      color index  color08  color00  "~R"        # read messages
      color index  color08  color00  "~d >45d"   # older than 45 days
      color index  color08  color00  "~v~(!~N)"  # collapsed thread with no unread
      color index  color08  color00  "~Q"        # messages that have been replied to

      ## Strong
      color index  color21  color00  "(~U|~N|~O)"     # unread, new, old messages
      color index  color21  color00  "~v~(~U|~N|~O)"  # collapsed thread with unread

      ## Highlight
      ### Trusted
      color index  color06  color00  "~g"  # PGP signed messages
      color index  color06  color00  "~G"  # PGP encrypted messages
      ### Odd
      color index  color01  color00  "~E"  # past Expires: header date
      color index  color01  color00  "~="  # duplicated
      color index  color01  color00  "~S"  # marked by Supersedes: header
      ### Flagged
      color index  color05  color00  "~F"       # flagged messages
      color index  color02  color00  "~v~(~F)"  # collapsed thread with flagged inside

      # Selection
      color index  color02  color18   "~T"  # tagged messages
      color index  color01  color18   "~D"  # deleted messages

      ### Message Headers ----------------------------------------------------

      # Base
      color hdrdefault  color07  color00
      color header      color07  color00  "^"
      # Strong
      color header      color21  color00  "^(From)"
      # Highlight
      color header      color04  color00  "^(Subject)"

      ### Message Body -------------------------------------------------------
      # When possible, these regular expressions attempt to match http://spec.commonmark.org/
      ## Weak
      # ~~~ Horizontal rules ~~~
      color body  color08  color00  "([[:space:]]*[-+=#*~_]){3,}[[:space:]]*"
      ## Strong
      # *Bold* span
      color body  color03  color00  "(^|[[:space:][:punct:]])\\*[^*]+\\*([[:space:][:punct:]]|$)"
      # _Underline_ span
      color body  color05  color00  "(^|[[:space:][:punct:]])_[^_]+_([[:space:][:punct:]]|$)"
      # /Italic/ span (Sometimes gets directory names)
      color body  color05  color00  "(^|[[:space:][:punct:]])/[^/]+/([[:space:][:punct:]]|$)"
      # ATX headers
      color body  color04  color00  "^[[:space:]]{0,3}#+[[:space:]].*$"
      ## Highlight
      # `Code` span
      color body  color02  color00  "(^|[[:space:][:punct:]])\`[^\`]+\`([[:space:][:punct:]]|$)"
      # Indented code block
      color body  color02  color00  "^[[:space:]]{4,}.*$"
      # URLs
      color body  color16 color00  "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"
      # Email addresses
      color body  color16 color00  "((@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\]),)*@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\]):)?[0-9a-z_.+%$-]+@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\])"
      # Emoticons ;-P
      color body  black   yellow   "[;:][-o]?[})>{(<|P]"

      # PGP
      color body  color21  color01   "(BAD signature)"
      color body  color21  color01   "^gpg: BAD signature from.*"
      color body  color21  color04   "(Good signature)"
      color body  color21  color04   "^gpg: Good signature .*"
      color body  color04  color00  "^gpg: "


      ## Quotation blocks
      color quoted   color06  color00
      color quoted1  color02  color00
      color quoted2  color03  color00
      color quoted3  color16  color00
      color quoted4  color01  color00
      color quoted5  color17  color00
      color quoted6  color05  color00
      color quoted7  color04  color00

      # vi: ft=muttrc

    '';
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

    sessionVariables = {
      AWS_SESSION_TOKEN_TTL = "8h";
      AWS_MIN_TTL = "8h";
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

    dirHashes = {
      proj = "$HOME/Projects";
    };

    oh-my-zsh = {
      enable = true;

      plugins = [ "common-aliases" "git" "sudo" "kubectl" "helm" "gcloud" "asdf" ];
    };

    shellAliases = {
      # Basic file aliases
      # managed by programs.lsd
      # ls = "lsd";
      # ll = "ls -halF";
      # la = "ls -A";
      # l = "ls -CF";
      rmdot = "rm -rf .[!.]*";

      doco = "docker compose";
      hm = "home-manager";
      vim = "lvim";

      ghcurl = "curl -H \"Authorization: token $GITHUB_TOKEN\"";

      lg = "lazygit";

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

  programs.git = {
    enable = true;

    userName = "Mark Sagi-Kazar";
    userEmail = "mark.sagikazar@gmail.com";

    signing = {
      key = "F4C5C90E";
      signByDefault = true;
    };

    aliases = {
      ci = "commit -s";
      st = "status";
      co = "checkout";
      comend = "commit --amend --no-edit";
      it = "!git init && git commit -m \"Root commit\" --allow-empty";
      yolo = "push --force-with-lease";
      shorty = "status --short --branch";
      today = "log --since=midnight --author='Mark Sagi-Kazar' --oneline";
      grog = "log --graph --abbrev-commit --decorate --all --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
    };

    extraConfig = {
      url."git@github.com:".insteadOf = "https://github.com";

      diff = {
        tool = "kitty";
        guitool = "kitty.gui";
      };

      difftool = {
        prompt = false;
        trustExitCode = true;
      };

      difftool."kitty".cmd = "kitty +kitten diff $LOCAL $REMOTE";
      difftool."kitty.gui".cmd = "kitty +kitten diff $LOCAL $REMOTE";
    };

    includes = [
      {
        condition = "gitdir:~/Projects/cisco/";
        contents = {
          user = {
            email = "marksk@cisco.com";
            signingkey = "";
          };

          commit = {
            gpgsign = false;
          };
        };
      }
    ];

    ignores = [
      ".idea/"
      ".idea/*"
      ".rocketeer/"
      ".phpspec/"
      ".vagrant/"
      ".floo"
      ".flooignore"
      ".phpbrewrc"
      ".DS_Store"
      ".jira-url"
      ".jira-prefix"
      ".vscode/*"
      ".wakatime-project"

      "users.txt"
      ".ant_targets"
      "atlassian-ide-plugin.xml"
      "auth.json"
      ".node-version"
      ".ssh/"
      ".php-version"
      ".python-version"

      "*.nupkg"

      "values.local.yaml"
    ];
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

    # karabiner = {
    #   source = ./dotfiles/karabiner;

    #   # Karabiner does not work well with symlinks
    #   # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
    #   recursive = false;
    #   # onChange = "launchctl kickstart -k gui/`id -u`/org.pqrs.karabiner.karabiner_console_user_server";
    # };

    # skhd = {
    #   source = ./dotfiles/skhd;
    #   recursive = true;
    # };

    # yabai = {
    #   source = ./dotfiles/yabai;
    #   recursive = true;
    # };

    "wgetrc" = {
      text = ''
        hsts-file = ${config.xdg.cacheHome}/wget-hsts
      '';
    };
  };

  xdg.fallback.enable = true;


  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "mark";
  # home.homeDirectory = "/home/mark";

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
