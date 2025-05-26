{
  description = "My Nix(OS) configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-managerUnstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs = {
        nixpkgs.follows = "nixpkgsUnstable";
      };
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    matrix-appservices.url = "gitlab:coffeetables/nix-matrix-appservices";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgsUnstable,
      nur,
      home-manager,
      home-managerUnstable,
      darwin,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;

      systemOverlay = (
        final: prev: {
          yabai = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.yabai;
          jankyborders = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.jankyborders;
          # davinci-resolve-studio = (import inputs.nixpkgsUnstable { system = prev.system; config.allowUnfree = true; }).davinci-resolve-studio;

          # Until 25.05
          # nerd-fonts = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.nerd-fonts;

          hyprland = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.hyprland;
          hyprlock = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.hyprlock;
          aquamarine = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.aquamarine;

          # https://github.com/NixOS/nixpkgs/issues/332812
          plymouth = prev.plymouth.overrideAttrs (
            { src, ... }:
            {
              version = "24.004.60-unstable-2024-12-15";

              src = src.override {
                rev = "a0e8b6cf50114482e8b5d17ac2e99ff0f274d4c5";
                hash = "sha256-XRSWdmGnckIGdsX7ihXK0RV3X9OphtGZcKQ6IW9FUBo=";
              };
            }
          );
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

          # Until 25.05
          # neovim-node-client = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.neovim-node-client;
          # nerd-fonts = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.nerd-fonts;

          hyprland = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.hyprland;
          hyprlock = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.hyprlock;
          aquamarine = inputs.nixpkgsUnstable.legacyPackages.${prev.system}.aquamarine;
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
              nixpkgs.overlays = [
                systemOverlay
                nur.overlays.default
              ];
            }
            ./modules/nixos

            ./hosts/mark-desktop
            ./users/mark/system
          ];
        };

        mark-g15 = inputs.nixpkgsUnstable.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            pkgs-unstable = import inputs.nixpkgsUnstable {
              config.allowUnfree = true;
              localSystem = { inherit system; };
            };
          };

          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                systemOverlay
                nur.overlay
              ];
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
              nixpkgs.overlays = [
                systemOverlay
                nur.overlays.default
              ];
            }
            ./modules/nixos

            ./hosts/mark-x1carbon9
          ];
        };

        moria = lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules = [
            {
              nixpkgs.overlays = [
                systemOverlay
                nur.overlays.default
              ];
            }

            ./hosts/moria/configuration.nix
          ];
        };
      };

      darwinConfigurations = {
        Mark-M1MBP = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";

          pkgs = import nixpkgsUnstable {
            inherit system;

            config.allowUnfree = true;

            overlays = [
              systemOverlay
            ];
          };

          modules = [
            {
              system.stateVersion = 5;
            }
            ./modules/nix-darwin
            ./hosts/Mark-M1MBP/configuration.nix
          ];
        };
        Mark-M2MBP = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";

          pkgs = import nixpkgsUnstable {
            inherit system;

            config.allowUnfree = true;

            overlays = [
              systemOverlay
            ];
          };

          modules = [
            {
              system.stateVersion = 5;
            }
            ./modules/nix-darwin
            ./hosts/Mark-M2MBP/configuration.nix
          ];
        };
        Mark-M4MBP = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";

          pkgs = import nixpkgsUnstable {
            inherit system;

            config.allowUnfree = true;

            overlays = [
              systemOverlay
            ];
          };

          modules = [
            {
              system.stateVersion = 5;
            }
            ./modules/nix-darwin
            ./hosts/Mark-M4MBP/configuration.nix
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
            ./users/mark/home/theme.nix
            ./users/mark/home/nixos/linux.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/neomutt.nix
            ./users/mark/home/programs/wezterm
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "mark@mark-g15" = home-managerUnstable.lib.homeManagerConfiguration rec {
          pkgs = import inputs.nixpkgsUnstable {
            system = "x86_64-linux";

            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "electron-25.9.0"
            ];

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
            ./users/mark/home/theme.nix
            ./users/mark/home/nixos/gtk.nix
            ./users/mark/home/nixos/linux.nix
            ./users/mark/home/nixos/hypr.nix
            ./users/mark/home/nixos/sway.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/neomutt.nix
            ./users/mark/home/programs/wezterm

            # {
            #   home.packages = with pkgs; [ sunsama morgen ];
            # }
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "mark@mark-x1carbon9" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgs {
            system = "x86_64-linux";

            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "electron-25.9.0"
            ];

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
            ./users/mark/home/theme.nix
            ./users/mark/home/nixos/linux.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/neomutt.nix
            ./users/mark/home/programs/wezterm
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "mark@Mark-M1MBP" = home-managerUnstable.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgsUnstable {
            system = "aarch64-darwin";

            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "electron-25.9.0"
            ];

            overlays = [ nur.overlays.default ];
          };

          modules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule

            # {
            #   programs.ghostty = {
            #     enable = true;
            #     # shellIntegration.enableZshIntegration = true;
            #
            #     settings = {
            #       font-family = "Iosevka Nerd Font Mono";
            #       theme = "dark:catppuccin-macchiato,light:catppuccin-latte";
            #     };
            #
            #   };
            # }

            {
              home = {
                username = "mark";
                homeDirectory = "/Users/mark";
                stateVersion = "20.09";
              };
            }

            ./home.nix
            ./home.darwin.nix
            ./users/mark/home/nix-colors.nix
            ./users/mark/home/theme.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/wezterm

            {
              programs.wakatime = {
                # Wakatime sucks
                enable = false;
                settings = {
                  settings = {
                    api_key_vault_cmd = "op read -n op://Personal/WakatimeAPIkey/credential";
                  };
                };
              };
            }

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

                # (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })
                nerd-fonts.fira-code
                nerd-fonts.iosevka
                nerd-fonts.jetbrains-mono

                font-awesome
                font-awesome_5
                # TODO: add SF pro

                clarity-city

                # go_1_20
                # impl
              ];
            }
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "mark@Mark-M2MBP" = home-managerUnstable.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgsUnstable {
            system = "aarch64-darwin";

            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "electron-25.9.0"
            ];

            overlays = [ nur.overlayd.default ];
          };

          modules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule

            {
              home = {
                username = "mark";
                homeDirectory = "/Users/mark";
                stateVersion = "20.09";
              };
            }

            ./home.nix
            ./home.darwin.nix
            ./users/mark/home/nix-colors.nix
            ./users/mark/home/theme.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/wezterm

            {
              programs.wakatime = {
                # Wakatime sucks
                enable = false;
                settings = {
                  settings = {
                    api_key_vault_cmd = "op read -n op://Personal/WakatimeAPIkey/credential";
                  };
                };
              };
            }

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

                # (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })
                nerd-fonts.fira-code
                nerd-fonts.iosevka
                nerd-fonts.jetbrains-mono

                font-awesome
                font-awesome_5
                # TODO: add SF pro

                clarity-city

                # go_1_20
                # impl
              ];
            }
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "mark@Mark-M4MBP" = home-managerUnstable.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgsUnstable {
            system = "aarch64-darwin";

            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "electron-25.9.0"
            ];

            overlays = [ nur.overlays.default ];
          };

          modules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule

            # {
            #   programs.ghostty = {
            #     enable = true;
            #     # shellIntegration.enableZshIntegration = true;
            #
            #     settings = {
            #       font-family = "Iosevka Nerd Font Mono";
            #       theme = "dark:catppuccin-macchiato,light:catppuccin-latte";
            #     };
            #
            #   };
            # }

            {
              home = {
                username = "mark";
                homeDirectory = "/Users/mark";
                stateVersion = "20.09";
              };
            }

            ./home.nix
            ./home.darwin.nix
            ./users/mark/home/nix-colors.nix
            ./users/mark/home/theme.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty
            ./users/mark/home/programs/wezterm

            {
              programs.wakatime = {
                # Wakatime sucks
                enable = false;
                settings = {
                  settings = {
                    api_key_vault_cmd = "op read -n op://Personal/WakatimeAPIkey/credential";
                  };
                };
              };
            }

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

                # (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })
                nerd-fonts.fira-code
                nerd-fonts.iosevka
                nerd-fonts.jetbrains-mono

                font-awesome
                font-awesome_5
                # TODO: add SF pro

                clarity-city

                ibm-plex

                # go_1_20
                # impl
              ];
            }
          ];

          extraSpecialArgs = { inherit inputs; };
        };
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # home-manager
            git

            nixos-rebuild

            sops
            age
            ssh-to-age
          ];
        };
      }
    );
}
