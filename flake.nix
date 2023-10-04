{
  description = "My Nix(OS) configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-managerUnstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, nur, home-manager, home-managerUnstable, darwin, ... }@inputs:
    let
      lib = nixpkgs.lib;

      systemOverlay = (
        final: prev: {
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
            ./hosts/MARKSK-M-1WLF
          ];
        };

        Mark-M2MBP = darwin.lib.darwinSystem rec {
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
            ./hosts/MARKSK-M-1WLF
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
                  sunsama = prev.appimageTools.wrapType2 rec {
                    name = "Sunsama";
                    version = "2.0.12";
                    src = prev.fetchurl {
                      url = "https://desktop.sunsama.com/versions/${version}/linux/appImage/x64";
                      sha256 = "sha256-MxXahIl1IbjZbeAlAoPcvpoll/Tsp4d4JRA4/lzFYjU=";
                    };
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

            {
              home.packages = with pkgs; [ sunsama morgen ];
            }
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "mark@mark-x1carbon9" = home-manager.lib.homeManagerConfiguration rec {
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

        "marksk@MARKSK-M-J1W8" = home-managerUnstable.lib.homeManagerConfiguration rec {
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
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "marksk@MARKSK-M-1WLF" = home-managerUnstable.lib.homeManagerConfiguration rec {
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

                (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })

                font-awesome
                font-awesome_5
                # TODO: add SF pro

                pkgs.nur.repos.sagikazarmark.clarity-city

                go_1_20
                impl
              ];
            }
          ];

          extraSpecialArgs = { inherit inputs; };
        };

        "mark@Mark-M2MBP" = home-managerUnstable.lib.homeManagerConfiguration rec {
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
                username = "mark";
                homeDirectory = "/Users/mark";
                stateVersion = "20.09";
              };
            }

            ./home.nix
            ./home.darwin.nix
            ./users/mark/home/nix-colors.nix
            ./users/mark/home/dev.nix
            ./users/mark/home/programs/git.nix
            ./users/mark/home/programs/kitty

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

                (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })

                font-awesome
                font-awesome_5
                # TODO: add SF pro

                pkgs.nur.repos.sagikazarmark.clarity-city

                # go_1_20
                # impl
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
