{ ... }:

{
  programs.kitty = {
    darwinLaunchOptions = [
      "--single-instance"
      "--directory=~"
    ];
  };
}
