{ pkgs, ... }:

{
  home.packages = with pkgs; [
    asdf-vm
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
    lnav
    nmap
    vault-bin

    postgresql
    jetbrains.datagrip

    # Git
    git
    git-filter-repo

    # LSP
    # rnix-lsp
    terraform-ls
    nodePackages.yaml-language-server
    nodePackages.typescript-language-server
    # sumneko-lua-language-server

    # Lua
    stylua
    lua54Packages.luacheck

    # Nix
    nixfmt
    nixpkgs-fmt
    nixpkgs-review
    nixos-generators

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
    fluxctl
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
  ];

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
      plugins = [ "kubectl" "helm" "gcloud" "asdf" ];
    };

    shellAliases = {
      doco = "docker compose";

      ghcurl = "curl -H \"Authorization: token $GITHUB_TOKEN\"";
    };
  };
}
