# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nix.binaryCachePublicKeys = [
    hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=
  ];
  nix.binaryCaches = [
    "https://hydra.iohk.io"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkbOptions = "ctrl:swapcaps";
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mauricio = {
    isNormalUser = true;
    home = "/home/mauricio";
    description = "Mauricio Fierro";
    extraGroups = [ "wheel" "network-manager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    cachix
    nvidia-offload
    nix-prefetch-git
    firefox
    htop
    curl
    gnome.gnome-tweaks
    vlc
    xclip
    xprop
  ];
  programs.steam.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.users.mauricio = { pkgs, ...  }: {
    # TODO: Failed to change ownership of firefox-old
    # probably because I installed it globally before
    # programs.firefox = {
    #   enable = true;
    #   package = pkgs.firefox.override {
    #     cfg.enableGnomeExtensions = true;
    #   };
    # };
    programs.direnv.enable = true;
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
    programs.ssh.enable = true;
    programs.tmux = {
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

        # Yank text using y
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

        # Get bottom split
        bind-key -n C-a splitw -v -p 25

        # Disable status bar
        set -g status off
      '';
    };

    programs.zsh = {
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
    };

    programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      plugins = let
      lightline-gruvbox = pkgs.vimUtils.buildVimPlugin {
        name = "lightline-gruvbox.vim";
        src = pkgs.fetchFromGitHub {
          owner = "sinchu";
          repo = "lightline-gruvbox.vim";
          rev = "21659af1fc980ebe7de0f475e57c3fda9a82c2d3";
          sha256 = "0h9br1r5vbrx5cplnk34xlg1kagasj3zn18f8d4ifi0pibyq6pm1";
        };
      };
      vim-tmux-navigator = pkgs.vimUtils.buildVimPlugin {
        name = "vim-tmux-navigator";
        src = pkgs.fetchFromGitHub {
          owner = "christoomey";
          repo = "vim-tmux-navigator";
          rev = "0cabb1ef01af0986b7bf6fb7acf631debdbbb470";
          sha256 = "0xxc5wpyfqv7f7sfy6xncy7ipj0cvshw28s12ld3jfgyimjllr62";
        };
      };
      fugitive = pkgs.vimUtils.buildVimPlugin {
        name = "vim-fugitive";
        src = pkgs.fetchFromGitHub {
          owner = "tpope";
          repo = "vim-fugitive";
          rev = "2a53d7924877b38b3d82fba188fd9053bfbc646e";
          sha256 = "17zafl9bj7szfzadwl245dhv5s4f14bcipksir95kw7h2lcwxxmx";
        };
      };
      in with pkgs.vimPlugins; [
        # TODO: Use gruvbox-nvim for treesitter support
        { plugin = ack-vim;
          config = ''
            let g:ackprg = 'ag --vimgrep --ignore tags'
          '';
        }
        { plugin = camelcasemotion;
          config = ''
            map <silent> w <Plug>CamelCaseMotion_w
            map <silent> b <Plug>CamelCaseMotion_b
            map <silent> e <Plug>CamelCaseMotion_e
            sunmap w
            sunmap b
            sunmap e
          '';
        }
        ctrlp-vim
        dhall-vim
        ghcid
        gruvbox
        haskell-vim
        { plugin = lightline-vim;
          config = ''
            let g:lightline = {}
            let g:lightline.colorscheme = 'gruvbox'
          '';
        }
        lsp-colors-nvim
        nerdtree
        nvim-lspconfig
        nvim-web-devicons # TODO: Why both?
        plenary-nvim
        purescript-vim
        { plugin = supertab;
          config = ''
          let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
          '';
        }
        # syntastic TODO: when adding ruby stuff
        #tlib_vim
        todo-comments-nvim
        trouble-nvim
        #vim-addon-mw-utils
        vim-better-whitespace
        vim-commentary
        vim-devicons # TODO: Why both?
        fugitive
        vim-gitgutter
        vim-javascript
        vim-jsx-pretty
        vim-nix
        #vim-snipmate
        vim-snippets
        vim-surround
        vim-vinegar
        lightline-gruvbox
        vim-tmux-navigator
        { plugin = vim-markdown;
          config = ''
          let g:vim_markdown_no_extensions_in_markdown = 1
          let g:vim_markdown_preview_hotkey='<C-m>'
          let g:vim_markdown_preview_github=1
          '';
        }
        # TODO: vim-reek isnt in nixos.
      ];
      extraPackages = [
        pkgs.ack
        pkgs.git
        pkgs.ripgrep
      ];
      extraConfig = ''
      syntax on
      colorscheme gruvbox
      set background=dark
      set showcmd
      set showmatch
      set ignorecase
      set smartcase
      set incsearch
      set encoding=UTF-8
      set autoindent
      set bufhidden=delete
      set nobackup
      set nowritebackup
      set nu
      set showmode
      set tw=90
      " TODO: Check this vs plugins rules
      set shiftwidth=2
      set tabstop=2
      set expandtab
      set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox,node_modules,dist*
      set wildmode=longest,list,full
      set wildmenu
      set completeopt+=longest
      set t_Co=256
      set cmdheight=2
      set updatetime=300
      set shortmess+=c
      set signcolumn=yes
      set noshowmatch
      set splitbelow
      set splitright
      set cursorline
      set laststatus=2

      " Load indentation rules and plugins according to the detected filetype.
      if has("autocmd")
        filetype plugin indent on
      endif

      if (has("termguicolors"))
        set termguicolors
      endif

      " Move to split buffers, even on terminal mode
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>
      tnoremap <Esc> <C-\><C-n>
      tnoremap <A-h> <C-\><C-n><C-w>h
      tnoremap <A-j> <C-\><C-n><C-w>j
      tnoremap <A-k> <C-\><C-n><C-w>k
      tnoremap <A-l> <C-\><C-n><C-w>l
      nnoremap <A-h> <C-w>h
      nnoremap <A-j> <C-w>j
      nnoremap <A-k> <C-w>k
      nnoremap <A-l> <C-w>l

      " Jump to definition using tags
      map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
      map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
      map <Leader>gs :Gstatus<CR>

      " Lua config
      lua << EOF
        require("trouble").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      EOF

      lua << EOF
      -- require'lspconfig'.hls.setup{}
      local nvim_lsp = require('lspconfig')

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

      end

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { "hls", "purescriptls" }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          },
        }
      end
      nvim_lsp["hls"].setup {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        cmd = { "haskell-language-server", "--lsp" }
      }
      EOF


      lua << EOF
      -- Trouble keybindings
      vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
        {silent = true, noremap = true}
      )
      EOF

      lua << EOF
        require("todo-comments").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      EOF
      '';
   };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

