{
  description = "My Nix(OS) configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        mark-g15 = lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./hosts/mark-g15/default.nix
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

          configuration = { };
        };

        "marksk@MARKSK-M-J1W8" = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-darwin";

          username = "marksk";
          homeDirectory = "/Users/marksk";

          pkgs = import nixpkgs {
            inherit system;
          };

          configuration = { };
        };
      };
    };
}