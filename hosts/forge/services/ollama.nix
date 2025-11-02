{ ... }:

{
  services.ollama = {
    enable = true;

    host = "[::]";

    acceleration = "cuda";
  };
}
