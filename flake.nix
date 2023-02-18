{
  description = "My Nix(OS) configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, nur, home-manager, darwin, ... }@inputs:
    let
      lib = nixpkgs.lib;

      systemOverlay = (
        final: prev: {
          keyd = prev.callPackage ./pkgs/keyd/default.nix { };
          yabai = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.yabai;
        }
      );

      linuxHomeOverlay = (
        final: prev: {
          neovim = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.neovim;
          waybar = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.waybar;
          scaleway-cli = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.scaleway-cli;
          gopls = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.gopls;
          whitesur-gtk-theme = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.whitesur-gtk-theme;
          whitesur-icon-theme = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.whitesur-icon-theme;
          lr-tech-rofi-themes = prev.callPackage ./pkgs/lr-tech-rofi-themes/default.nix { };
        }
      );
    in
    {
      nixosConfigurations = {
        mark-desktop = lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules = [
            {
              nixpkgs.overlays = [ systemOverlay nur.overlay ];
            }
            ./modules/nixos

            ./hosts/mark-desktop
            ./users/mark/system
          ];
        };

        mark-g15 = lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules = [
            {
              nixpkgs.overlays = [ systemOverlay nur.overlay ];
            }
            ./modules/nixos

            ./hosts/mark-g15
            ./users/mark/system
          ];
        };

        mark-x1carbon9 = lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules = [
            {
              nixpkgs.overlays = [ systemOverlay nur.overlay ];
            }
            ./modules/nixos

            ./hosts/mark-x1carbon9
          ];
        };
      };

      darwinConfigurations = {
        MARKSK-M-1WLF = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";

          pkgs = import nixpkgs {
            inherit system;

            config.allowUnfree = true;

            overlays = [
              systemOverlay
            ];
          };

          modules = [
            ./modules/nix-darwin/modules/env.nix
            {
              programs.bash.enable = false;
              # programs.zsh.enable = true;
            }
            {
              nix.extraOptions = ''
                experimental-features = nix-command flakes
              '';

              # nix.useDaemon = true;
              services.nix-daemon.enable = true;
              # services.nix-daemon.enableSocketListener = true;
            }
            {
              # Set keyboard speed
              system.defaults.NSGlobalDomain.KeyRepeat = 1;
              system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;

              # Enable dark mode
              system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

              # Automatically hide and show the Dock
              system.defaults.dock.autohide = true;

              # Disable automatic rearrange of spaces
              system.defaults.dock.mru-spaces = false;

              # Displays have separate spaces
              system.defaults.spaces.spans-displays = true;

              # Smart settings
              # https://derflounder.wordpress.com/2014/02/01/disabling-smart-quotes-in-mavericks/
              system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
              system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
              system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
              system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
            }
            {
              environment.systemPackages = [
                # Install skhd for manual invocations (the module does not install it in path)
                pkgs.skhd
              ];
              services.skhd.enable = true;

              services.yabai = {
                enable = true;
                enableScriptingAddition = false;

                package = pkgs.yabai;

                # package = pkgs.yabai.overrideAttrs (finalAttrs: previousAttrs: {
                #   src = ./bin/yabai-v5.0.1.tar.gz;
                # });
              };
            }
            {
              homebrew = {
                enable = true;

                onActivation = {
                  cleanup = "zap";
                };

                taps = [
                  "homebrew/cask"
                  "homebrew/cask-drivers"
                ];

                brews = [
                  "mas"
                  "trash"

                  # Nix version is broken at the moment
                  "oci-cli"
                ];

                casks = [
                  # Apps
                  "1password"
                  "1password-cli"
                  "adobe-acrobat-reader"
                  "caffeine"
                  "calibre"
                  "chromium"
                  "colorsnapper"
                  "daisydisk"
                  "discord"
                  "gpg-suite"
                  "firefox"
                  "flux"
                  "insync"
                  "karabiner-elements"
                  "little-snitch"
                  "micro-snitch"
                  "microsoft-teams"
                  "monitorcontrol"
                  "notion"
                  "obs"
                  "obs-websocket"
                  "spotify"
                  "todoist"
                  "transmit"
                  "tuxera-ntfs"
                  "vuescan"
                  "vlc"
                  "raycast"

                  "signal"
                  "postbox"
                  "telegram"
                  # "telegram-desktop"

                  "darktable"
                  "inkscape"

                  # Dev
                  "docker"
                  "tableplus"

                  "logitech-options"
                ];

                masApps = {
                  "DaVinci Resolve" = 571213070;
                };
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "mark@mark-desktop" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgs {
            system = "x86_64-linux";

            config.allowUnfree = true;

            overlays = [
              linuxHomeOverlay
            ];
          };

          modules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule

            {
              home = {
                username = "mark";
                homeDirectory = "/home/mark";
                stateVersion = "20.09";
              };
            }

            ./home.nix
            ./users/mark/home/nix-colors.nix
            ./users/mark/home/linux.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/neomutt.nix
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "mark@mark-g15" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgs {
            system = "x86_64-linux";

            config.allowUnfree = true;

            overlays = [
              linuxHomeOverlay

              (
                final: prev: {
                  libsForQt5 = prev.libsForQt5 // {
                    qtstyleplugin-kvantum = prev.libsForQt5.qtstyleplugin-kvantum.overrideAttrs (
                      o: rec {
                        patches = [ ./pkgs/kvantum/kvantum.patch ];
                        patchFlags = [ "-p2" ];
                        cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=$(out)" ];
                        makeFlags = [ "PREFIX=$(out)" ];
                      }
                    );
                  };
                }
              )
            ];
          };

          modules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule

            {
              home = {
                username = "mark";
                homeDirectory = "/home/mark";
                stateVersion = "20.09";
              };
            }

            ./home.nix
            ./users/mark/home/nix-colors.nix
            ./users/mark/home/gtk.nix
            ./users/mark/home/linux.nix
            ./users/mark/home/sway.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/neomutt.nix
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "marksk@MARKSK-M-J1W8" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgsUnstable {
            system = "x86_64-darwin";

            config.allowUnfree = true;

            overlays = [ ];
          };

          modules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule

            {
              home = {
                username = "marksk";
                homeDirectory = "/Users/marksk";
                stateVersion = "20.09";
              };
            }

            ./home.nix
            ./home.darwin.nix
            ./users/mark/home/nix-colors.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/neomutt.nix
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "marksk@MARKSK-M-1WLF" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgsUnstable {
            system = "aarch64-darwin";

            config.allowUnfree = true;

            overlays = [ nur.overlay ];
          };

          modules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule

            {
              home = {
                username = "marksk";
                homeDirectory = "/Users/marksk";
                stateVersion = "20.09";
              };
            }

            ./home.nix
            ./home.darwin.nix
            ./users/mark/home/nix-colors.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/neomutt.nix

            {
              home.packages = with pkgs; [
                fira-code
                fira-code-symbols
                iosevka
                jetbrains-mono
                merriweather
                merriweather-sans
                roboto
                roboto-slab
                roboto-mono
                montserrat
                lato

                (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })

                font-awesome
                font-awesome_5

                go_1_19
              ];
            }
          ];

          extraSpecialArgs = { inherit inputs; };
        };
      };
    } // inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ home-manager git ];
        };
      }
    );
}
