# Installing Nix on Darwin

This page explains installing my Nix setup on an empty Darwin (macOS) computer.
If you've just unboxed or wiped your computer, you are ready to go.

Most of the instructions should work for any Flake-based setups (using [nix-darwin](https://github.com/LnL7/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager)).

> [!TIP]
> Open this page in Safari to follow the instructions or enable SSH under _General_ -> _Sharing_ -> _Remote Login_ and run commands in a remote terminal.

## Preparation

### Disable SIP

If you intend to use [Yabai](https://github.com/koekeishiya/yabai),
follow [these](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
steps before proceeding with installation to disable SIP (System Integrity Protection).

> [!NOTE]
> Technically, this step is optional, but **highly recommended** for an optimal experience.

### Install XCode command line tools

Next, install command line developer tools:

```shell
xcode-select --install
```

Follow the installation instructions appearing on screen.

### Ensure host name is correct

Make sure your host name matches with the name in `flake.nix`:

```shell
hostname -s
```

If it doesn't, change your computer name and host name using the following commands:

```shell
sudo scutil --set HostName YOUR_HOSTNAME
sudo scutil --set LocalHostName YOUR_HOSTNAME
sudo scutil --set ComputerName YOUR_HOSTNAME
```

### Install Homebrew

Go to the [Homebrew website](https://brew.sh/) and follow the installation instructions.

**Do not run the post-install steps.**

## Installing Nix

Run the following command to install Nix:

```shell
sh <(curl -L https://nixos.org/nix/install)
```

Answer yes to the questions and enter your password when asked.

Go and get yourself a cup of coffee while Nix does it's thing. ☕

Open a new terminal and check that Nix is available:

```shell
nix
```

## Setting up the user environment

Clone this repository:

```shell
git clone https://github.com/sagikazarmark/nix-config.git
cd nix-config
```

Apply the Darwin configuration for your host:

```shell
nix --extra-experimental-features nix-command --extra-experimental-features flakes run --no-write-lock-file nix-darwin -- switch --flake .
```

Stretch your legs while Nix does it's magic. 🚶

**Open a new terminal to reload the shell.**

After applying the configuration for the first time, you can run the following command instead:

```shell
darwin-rebuild switch --flake .
```

Apply the Darwin configuration for your host:

```shell
nix run --no-write-lock-file github:nix-community/home-manager/master -- switch --flake .
```

Stretch your legs while Nix does it's thing. 🚶

Reboot your computer to make sure every configuration is reloaded.

Enjoy!
