# My Nix(OS) configurations

[![System](https://github.com/sagikazarmark/nix-config/workflows/System/badge.svg)](https://github.com/sagikazarmark/nix-config/actions)
[![Home](https://github.com/sagikazarmark/nix-config/workflows/Home/badge.svg)](https://github.com/sagikazarmark/nix-config/actions)

This repository hosts my [NixOS](https://nixos.org/) and [home-manager](https://github.com/nix-community/home-manager) configurations.

## Installation

### Preparing a new machine

When installing Nix/NixOS on a new machine for the first time,
make sure you complete the following steps:

1. Figure out a hostname for your machine.
1. Create a new system configuration under `nixosConfigurations` (or `darwinConfigurations`) in `flake.nix`.
1. Create a new directory under `hosts/` for your new host.
1. Create a new home configuration under `homeConfigurations` in the form of `user@host`.

### Installing NixOS

Follow the steps [here](./docs/install-nixos.md) to install NixOS.

### Installing Nix on Darwin

Follow the steps [here](./docs/install-nix-darwin.md) to install Nix on Darwin.

## References

### Installation guides

- https://nixos.org/manual/nixos/stable/index.html#sec-installation
- https://nixos.wiki/wiki/NixOS_Installation_Guide
- https://wiki.archlinux.org/title/installation_guide
- https://blog.tuxinaut.de/2018/05/07/part-1-installing-nixos/

### Encryption

- https://nixos.wiki/wiki/Full_Disk_Encryption
- https://dzone.com/articles/nixos-native-flake-deployment-with-luks-and-lvm
- https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f
- https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134

### Config examples

- https://github.com/jonringer/nixpkgs-config
- https://github.com/kclejeune/system
- https://github.com/Misterio77/nix-config
- https://github.com/ttuegel/nixos-config
- https://github.com/vidbina/nixos-configuration
- https://github.com/wiltaylor/dotfiles
- https://github.com/foo-dogsquared/nixos-config
- https://github.com/jared-w/nixos-configs
- https://github.com/gvolpe/nix-config

Collection of Nix setups: https://nixos.wiki/wiki/Comparison_of_NixOS_setups

### Misc

- https://gvolpe.com/blog/nixos-binary-cache-ci/
- https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Setting-the-Mac-hostname-or-computer-name-from-the-terminal.html
