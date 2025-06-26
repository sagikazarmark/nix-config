{ pkgs, lib, ... }:

{
  home.packages =
    with pkgs;
    [
      terraform
      caddy
      cue
      hostctl
      gh
      k6
      # mitmproxy # does not build on silicone because of pyopenssl
      mkcert
      nodejs
      yarn
      protobuf
      tunnelto
      # lnav
      nmap
      vault-bin

      postgresql
      jetbrains.datagrip

      # Git
      git
      git-filter-repo

      # Nix
      nil

      # LSP
      # rnix-lsp
      terraform-ls
      helm-ls
      nodePackages.yaml-language-server
      nodePackages.typescript-language-server
      lua-language-server
      vscode-langservers-extracted

      # Lua
      stylua
      lua54Packages.luacheck
      selene

      # Nix
      # nixfmt
      # nixfmt-classic
      nixfmt-rfc-style
      nixpkgs-fmt
      nixpkgs-review
      nixos-generators
      nixd
      nil

      statix
      alejandra
      deadnix

      # Cloud
      awscli2
      aws-vault
      # azure-cli
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      scaleway-cli

      # Go
      go
      gopls
      impl
      gomodifytags
      golangci-lint
      revive
      go-tools
      gofumpt

      # Rust
      cargo
      rust-analyzer
      lldb

      gnumake
      gcc

      # For protobuf formatting
      # clang
      clang-tools

      # Docker
      hadolint
      nodePackages.dockerfile-language-server-nodejs
      docker-compose-language-service

      # TOML
      taplo

      # Markdown
      marksman
      markdownlint-cli2

      # Terraform
      terraform-ls

      # Containers
      lima
      # podman
      # podman-compose # Not supported on darwin
      skopeo

      # Kubernetes
      kubectl
      krew
      kubetail
      kubectx
      kubie
      rakkess
      minikube
      kubernetes-helm
      kind
      # kail # Not maintained
      # popeye # Not supported on darwin
      # k3s # Not supported on darwin
      k9s
      skaffold
      stern
      kustomize
      # kubeval # Not maintained
      aws-iam-authenticator
      telepresence2
      argocd
      helm-docs

      # nodePackages.snyk

      # vagrant # BROKEN on darwin aarch64
      # openstackclient

      # wkhtmltopdf
      plantuml
      graphviz

      ollama

      just
    ]
    # https://github.com/NixOS/nixpkgs/pull/357675#issuecomment-2504709640
    ++ lib.optional (!pkgs.stdenv.isDarwin) pkgs.lnav;

  home.sessionPath = [
    # Go binaries
    "$HOME/.local/share/go/bin"

    # Rust binaries
    "$HOME/.cargo/bin"
    "$HOME/.local/share/cargo/bin"
    "$HOME/.local/share/npm/bin"

    # NPM binaries
    "$XDG_DATA_HOME/npm/bin"

    # Krew binaries
    "\${KREW_ROOT:-$HOME/.krew}/bin"
  ];

  programs.zsh = {
    sessionVariables = {
      AWS_SESSION_TOKEN_TTL = "8h";
      AWS_MIN_TTL = "8h";
    };

    dirHashes = {
      proj = "$HOME/Projects";
    };

    oh-my-zsh = {
      plugins = [
        "kubectl"
        "helm"
        "gcloud"
        "asdf"
      ];
    };

    shellAliases = {
      doco = "docker compose";

      ghcurl = ''curl -H "Authorization: token $GITHUB_TOKEN"'';
    };
  };

  programs.asdf-vm = {
    enable = true;
    package = pkgs.nur.repos.sagikazarmark.asdf-vm;
  };
}
