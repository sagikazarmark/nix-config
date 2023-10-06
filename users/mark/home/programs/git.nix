{ ... }:

{
  programs.lazygit = {
    enable = true;
    enableShellAliases = true;
  };

  programs.zsh = {
    oh-my-zsh = {
      plugins = [ "git" ];
    };
  };

  programs.git = {
    enable = true;

    userName = "Mark Sagi-Kazar";
    userEmail = "mark.sagikazar@gmail.com";

    signing = {
      key = "F4C5C90E";
      signByDefault = true;
    };

    aliases = {
      ci = "commit -s";
      st = "status";
      co = "checkout";
      comend = "commit --amend --no-edit";
      it = "!git init && git commit -m \"Root commit\" --allow-empty";
      yolo = "push --force-with-lease";
      shorty = "status --short --branch";
      today = "log --since=midnight --author='Mark Sagi-Kazar' --oneline";
      grog = "log --graph --abbrev-commit --decorate --all --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
    };

    extraConfig = {
      # url."git@github.com:".insteadOf = "https://github.com";

      init.defaultBranch = "main";

      diff = {
        tool = "kitty";
        guitool = "kitty.gui";
      };

      difftool = {
        prompt = false;
        trustExitCode = true;
      };

      difftool."kitty".cmd = "kitty +kitten diff $LOCAL $REMOTE";
      difftool."kitty.gui".cmd = "kitty +kitten diff $LOCAL $REMOTE";
    };

    includes = [
      {
        condition = "gitdir:~/Projects/cisco/";
        contents = {
          user = {
            email = "marksk@cisco.com";
            signingkey = "";
          };

          commit = {
            gpgsign = false;
          };
        };
      }
    ];

    ignores = [
      ".idea/"
      ".idea/*"
      ".rocketeer/"
      ".phpspec/"
      ".vagrant/"
      ".floo"
      ".flooignore"
      ".phpbrewrc"
      ".DS_Store"
      ".jira-url"
      ".jira-prefix"
      ".vscode/*"
      ".wakatime-project"

      "users.txt"
      ".ant_targets"
      "atlassian-ide-plugin.xml"
      "auth.json"
      ".node-version"
      ".ssh/"
      ".php-version"
      ".python-version"

      "*.nupkg"

      "values.local.yaml"
    ];
  };
}
