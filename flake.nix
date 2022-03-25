{
  description = "My Nix(OS) configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        mark-g15 = lib.nixosSystem {
          system = "x86_64-linux";

	  pkgs = import nixpkgs {
            inherit system;

	    config.allowUnfree = true;
	  };

	  specialArgs = { inherit inputs; };

          modules = [
            ./hosts/mark-g15
            ./users/mark/system
          ];
        };
      };

      homeConfigurations = {
        "mark@mark-g15" = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";

          username = "mark";
          homeDirectory = "/home/mark";

          pkgs = import nixpkgs {
            inherit system;
          };

          extraModules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule
          ];

          extraSpecialArgs = { inherit inputs; };

          configuration = {
            imports = [
              ./home.nix
              ./users/mark/home/linux.nix
              ./users/mark/home/dev.nix
              ./users/mark/home/programs/git.nix
              ./users/mark/home/programs/kitty.nix
              ./users/mark/home/programs/neomutt.nix
            ];
          };
        };

        "marksk@MARKSK-M-J1W8" = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-darwin";

          username = "marksk";
          homeDirectory = "/Users/marksk";

          pkgs = import nixpkgsUnstable {
            inherit system;
          };

          extraModules = [
            ./modules/home-manager
            inputs.nix-colors.homeManagerModule
          ];

          extraSpecialArgs = { inherit inputs; };

          configuration = {
            imports = [
              ./home.nix
              ./home.darwin.nix
              ./users/mark/home/dev.nix
              ./users/mark/home/programs/git.nix
              ./users/mark/home/programs/kitty.nix
              ./users/mark/home/programs/kitty.darwin.nix
              ./users/mark/home/programs/neomutt.nix
            ];
          };
        };
      };
    } // inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ home-manager git ];
        };
      });
}
