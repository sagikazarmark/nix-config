{ ... }:

{
  services.ollama = {
    enable = true;

    host = "[::]";

    acceleration = "cuda";

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "30000";
    };
  };
}
