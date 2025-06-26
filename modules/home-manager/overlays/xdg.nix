# XDG Base Directory Specification related settings and overrides.
#
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# https://wiki.archlinux.org/index.php/XDG_Base_Directory

# Althouth the specification states that applications should
# fall back to the default paths if the environment variables are not defined,
# not all applications comply (fully) with the specification.
# Furthermore, it's easier to refer to these variables directly in some cases.

{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.xdg;
in
{
  options = {
    xdg.fallback = {
      enable = mkEnableOption "add fallback environment variables for software that do not support the XDG specification";
    };
  };

  config = mkIf (cfg.enable && cfg.fallback.enable) {
    home.sessionVariables = {
      ANSIBLE_CONFIG = "${cfg.configHome}/ansible/ansible.cfg";

      AZURE_CONFIG_DIR = "${cfg.dataHome}/azure";
      AWS_SHARED_CREDENTIALS_FILE = "${cfg.configHome}/aws/credentials";
      AWS_CONFIG_FILE = "${cfg.configHome}/aws/config";

      BOTO_CONFIG = "${cfg.configHome}/aws/boto";

      CARGO_HOME = "${cfg.dataHome}/cargo";

      COMPOSER_HOME = "${cfg.configHome}/composer";
      COMPOSER_CACHE_DIR = "${cfg.cacheHome}/composer";

      GOPATH = "${cfg.dataHome}/go";

      # This messes up gpg with systemd
      # See https://wiki.archlinux.org/index.php/GnuPG#gpg-agent
      # GNUPGHOME = "${cfg.dataHome}/gnupg"

      JFROG_CLI_HOME_DIR = "${cfg.dataHome}/jfrog";

      K9SCONFIG = "${cfg.configHome}/k9s";
      KREW_ROOT = "${cfg.dataHome}/krew";

      LIMA_HOME = "${cfg.dataHome}/lima";

      MINIKUBE_HOME = "${cfg.dataHome}/minikube";
      MAGEFILE_CACHE = "${cfg.cacheHome}/magefile";

      NODE_REPL_HISTORY = "${cfg.dataHome}/node_repl_history";
      npm_config_userconfig = "${cfg.configHome}/npm/config";
      npm_config_cache = "${cfg.cacheHome}/npm";
      # if you do this one, make sure to add $XDG_DATA_HOME/npm/bin to the $PATH,
      # otherwise global installed executables won't be accessible on the cli.
      npm_config_prefix = "${cfg.dataHome}/npm";

      OCI_CLI_RC_FILE = "${cfg.configHome}/oci/oci_cli_rc";

      REDISCLI_RCFILE = "${cfg.configHome}/redis/redisclirc";
      REDISCLI_HISTFILE = "${cfg.dataHome}/rediscli/history";
      RUSTUP_HOME = "${cfg.dataHome}/rustup";

      WINEPREFIX = "${cfg.dataHome}/wineprefixes/default";

      # WAKATIME_HOME = "${cfg.configHome}/wakatime";
      WGETRC = "${cfg.configHome}/wgetrc";
      WD_CONFIG = "${cfg.configHome}/wd/warprc";
    };
  };
}
