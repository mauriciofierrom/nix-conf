{ pkgs, ...}: {
  enable = true;
  prefix = "C-y";
  terminal = "xterm-256color";
  escapeTime = 0;
  tmuxinator.enable = true;
  keyMode = "vi";
  plugins = with pkgs.tmuxPlugins; [
    gruvbox
    yank
    vim-tmux-navigator
  ];
  extraConfig = ''
    # Select text using v
    bind-key -T copy-mode-vi 'v' send -X begin-selection

    # Get bottom split
    bind-key -n C-a splitw -v -p 25

    # Allow scrolling with mouse in panes
    set-option -g mouse on

    # Disable status bar
    set -g status off
  '';
}
