{ pkgs, ... }:

{
  home.packages = with pkgs; [
    asdf-vm
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
    yarn
    protobuf
    tunnelto
    lnav
    nmap
    vault-bin

    rnix-lsp
    terraform-ls
    nodePackages.yaml-language-server
    nodePackages.typescript-language-server
    sumneko-lua-language-server

    # Nix
    nixfmt
    nixpkgs-fmt
    nixpkgs-review
    nixos-generators

    # Cloud
    awscli2
    aws-vault
    # azure-cli
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    scaleway-cli

    # Go
    # go
    gofumpt
    gopls

    # Rust
    cargo

    gnumake
    gcc

    # For protobuf formatting
    # clang
    clang-tools

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

    nodePackages.snyk

    vagrant
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
