{ pkgs, ...}: {
  mauricio = {
    home.stateVersion = "24.11";
    # TODO: Failed to change ownership of firefox-old
    # probably because I installed it globally before
    # programs.firefox = {
    #   enable = true;
    #   package = pkgs.firefox.override {
    #     cfg.enableGnomeExtensions = true;
    #   };
    # };
    home.sessionPath = [
      "$HOME/.emacs.d/bin"
    ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.ssh.enable = true;
    programs.gpg.enable = true;
    # Doom Emacs + deps
    programs.emacs.enable = true;
    # TODO: Check the delta configs, looks neat.
    programs.git = {
      enable = true;
      userEmail = "mauriciofierrom@gmail.com";
      userName = "Mauricio Fierro";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };
    programs.tmux = import ./tmux.nix { inherit pkgs; };
    programs.zsh = import ./zsh.nix { inherit pkgs; };
    programs.neovim = import ./neovim.nix { inherit pkgs; };
    programs.vscode = import ./vscode.nix { inherit pkgs; };
  };
}
