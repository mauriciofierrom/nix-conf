{ pkgs, ... }: {
  enable = true;
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
  vim-syntax-shakespeare = pkgs.vimUtils.buildVimPlugin {
    name = "vim-syntax-shakespeare";
    src = pkgs.fetchFromGitHub {
      owner = "pbrisbin";
      repo = "vim-syntax-shakespeare";
      rev = "2f4f61eae55b8f1319ce3a086baf9b5ab57743f3";
      sha256 = "0h79c3shzf08g7mckc7438vhfmxvzz2amzias92g5yn1xcj9gl5i";
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
    indentLine
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
    vim-elixir
    purescript-vim
    # { plugin = supertab;
    #   config = ''
    #   let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
    #   '';
    # }
    {
      plugin = syntastic;
      config = ''
      let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['haskell'],'passive_filetypes': [] }
      let g:syntastic_always_populate_loc_list = 1
      let g:syntastic_auto_loc_list = 0
      let g:syntastic_check_on_open = 1
      let g:syntastic_check_on_wq = 1
      '';
    }
    #tlib_vim
    todo-comments-nvim
    trouble-nvim
    #vim-addon-mw-utils
    vim-better-whitespace
    vim-commentary
    vim-devicons # TODO: Why both?
    fugitive
    vim-rhubarb
    { plugin = vim-syntax-shakespeare;
      config = ''
      let g:hamlet_prevent_invalid_nesting = 0
      let g:hamlet_highlight_trailing_space = 0
      '';
    }
    vim-gitgutter
    vim-javascript
    vim-jsx-pretty
    vim-nix
    # vim-snipmate
    vim-snippets

    # Completion
    vim-vsnip
    vim-vsnip-integ
    friendly-snippets
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
    nvim-cmp

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
  set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox,node_modules,dist*,output
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
  map <Leader>gs :Git<CR>

  " Format on save
  autocmd BufWritePre *.hs lua vim.lsp.buf.formatting_sync(nil, 1000)
  autocmd BufWritePre *.purs lua vim.lsp.buf.formatting_sync(nil, 1000)

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

  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  nvim_lsp["hls"].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    cmd = { "haskell-language-server", "--lsp" },
    capabilities = capabilities
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

  lua <<EOF

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  -- nvim-cmp
  local cmp = require'cmp'
  cmp.setup({
    completion = {
      autocomplete = false,
    },
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
  '';
}
