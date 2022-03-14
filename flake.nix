{
  description = "My Nix(OS) configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
  };

  outputs = { self, nixpkgs }@inputs:
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
    };
}
