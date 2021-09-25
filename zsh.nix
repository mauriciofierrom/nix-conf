{ pkgs, ...}: {
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  #enableSyntaxHighlighting = true;
  initExtra = ''eval "$(direnv hook bash)"'';
  dirHashes = {
    haskell = "$HOME/projects/haskell";
    software = "$HOME/Software";
  };

  shellAliases = {
    u = "cd ..";
    t = "tree -L";
    t1 = "tree -L 1";
    ts = "tmuxinator";
    cb = "cabal build";
    cbe = "cabal build && cabal exec $(basename $(pwd))";
    update = "sudo nixos-rebuild switch";
  };

  history = {
    size = 10000;
    path = "/home/mauricio/.zsh_history";
  };

  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "heroku" "pip" "lein" "command-not-found" ];
  };

  zplug = {
    enable = true;
    plugins = [
      { name = "zsh-users/zsh-syntax-highlighting"; } # TODO: unstable has this as an option
      { name = "spaceship-prompt/spaceship-prompt";
        tags = [as:theme from:github use:spaceship.zsh ];
      }
    ];
  };
}
