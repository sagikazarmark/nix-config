{ inputs, ... }:

{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
  };
}
