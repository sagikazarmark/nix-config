{ pkgs, ... }:

{
  services.ollama = {
    enable = true;

    package = pkgs.ollama-cuda;

    host = "[::]";

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "30000";
    };
  };
}
