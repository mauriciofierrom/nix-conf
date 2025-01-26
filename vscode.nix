{pkgs, ...}: {
  enable = true;
  extensions = with pkgs; [
    vscode-extensions.mkhl.direnv
    vscode-extensions.bbenoist.nix
    vscode-extensions.github.github-vscode-theme
    vscode-extensions.eamodio.gitlens
    vscode-extensions.donjayamanne.githistory
    vscode-extensions.elixir-lsp.vscode-elixir-ls
    vscode-extensions.gruntfuggly.todo-tree
    vscode-extensions.alefragnani.bookmarks
    vscode-extensions.haskell.haskell
  ];
  userSettings = {
    "editor.fontFamily" = "'Monaspace Neon', monospace";
    "editor.minimap.enabled" = false;
    "editor.renderWhitespace" = "all";
    "editor.overviewRulerBorder" = false;
    "editor.hideCursorInOverviewRuler" = true;
    "editor.occurrencesHighlight" = false;
    "editor.tabSize" = 2;
    "workbench.activityBar.visible" = false;
    "workbench.editor.tabCloseButton" = "off";
    "window.menuBarVisibility" = "toggle";
    "workbench.editor.showTabs" = false;
    "workbench.colorTheme" = "GitHub Dark Default";
    "workbench.editor.limit.enabled" = true;
    "workbench.editor.limit.perEditorGroup" = true;
    "workbench.editor.limit.value" = 1;
  };
}
