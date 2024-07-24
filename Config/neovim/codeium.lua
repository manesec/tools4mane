-- PDE of manesec modified version :P
-- Github: Tools4mane https://github.com/manesec/Tools4mane
--

-- force tab 4
local set = vim.opt -- set options
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4


-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  -- file history 
  use 'nvim-lua/plenary.nvim'
  use 'gaborvecsei/memento.nvim'
 
  -- formatter
	use { 
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup()
		end
	}

  -- codeium
  use {
     'Exafunction/codeium.vim',
     config = function ()
       -- Change '<C-g>' here to any keycode you like.
       vim.keymap.set('i', '<C-f>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
       -- vim.keymap.set('i', '<C-a>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
       vim.keymap.set('i', '<C-d>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
       -- vim.keymap.set('i', '<C-s>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
     end
  } 


  -- love Top Line config
  use 'johann2357/nvim-smartbufs'
  use {'ojroques/nvim-hardline'}

  -- Auto command auto completion
  use { 'gelguy/wilder.nvim' }

  -- Undo history :UndotreeToggle
  use 'mbbill/undotree'

  -- glow for readmeeee :P
  use {"ellisonleao/glow.nvim", config = function() require("glow").setup() end}

  -- COQ Nvim for python3

  use { 'ms-jpq/coq_nvim', run = 'python3 -m coq deps' }
  use 'ms-jpq/coq.artifacts'
  use 'ms-jpq/coq.thirdparty'

  use { "nvim-neotest/nvim-nio" }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- Theme 0
  use 'navarasu/onedark.nvim' -- Theme inspired by Atom

  -- Theme 1, dark light
  -- use {
  --     'uloco/bluloco.nvim',
  --     requires = { 'rktjmp/lush.nvim' }
  -- }
  -- End theme 1

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  use { 'CRAG666/code_runner.nvim', requires = 'nvim-lua/plenary.nvim' } -- Code Runner

  use {    -- Add tree
    'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons
      }
  }

  use {  -- Auto pair
    "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
  }

  use 'mfussenegger/nvim-dap' -- Add debug support
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} } -- CUI of debug windows

  use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

  use { -- color code block
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup {
        dimming = {
          alpha = 0.25, -- amount of dimming
          -- we try to get the foreground from the highlight groups or fallback color
          color = { "Normal", "#ffffff" },
          term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
          inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
        },
        context = 10, -- amount of lines we will try to show around the current line
        treesitter = true, -- use treesitter when available for the filetype
        -- treesitter is used to automatically expand the visible text,
        -- but you can further control the types of nodes that should always be fully expanded
        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
          "function",
          "method",
          "table",
          "if_statement",
        },
        exclude = {}, -- exclude these filetypes
      }
    end
  }


  -- Map
  use 'echasnovski/mini.map'

  -- Symbols outline
  use 'simrat39/symbols-outline.nvim'

  -- Theme 1
  -- use {vim
  --     'uloco/bluloco.nvim',
  --     requires = { 'rktjmp/lush.nvim' }
  -- }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '     This is PDE for manesec.'
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})


-- [[ VIM Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme / theme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]
-- vim.cmd [[colorscheme bluloco-dark]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- UFO Config
require('ufo').setup()
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', '+', require('ufo').openAllFolds, { desc = 'openAllFolds' })
vim.keymap.set('n', '=', require('ufo').openFoldsExceptKinds, { desc = 'openAllFolds' })
vim.keymap.set('n', '_', require('ufo').closeAllFolds, { desc = 'closeAllFolds' })
vim.keymap.set('n', '-', function ()
   require('ufo').closeFoldsWith(1)
 end , { desc = 'closeAllFolds' })

-- Resize Windows
vim.keymap.set('n', '<C-S-Right>', function() vim.api.nvim_command('vertical resize +1') end)
vim.keymap.set('n', '<C-S-Left>', function() vim.api.nvim_command('vertical resize -1') end)
vim.keymap.set('n', '<C-S-Up>', function() vim.api.nvim_command('resize -1') end)
vim.keymap.set('n', '<C-S-Down>', function() vim.api.nvim_command('resize +1') end)

-- Top bar key binding ...
vim.keymap.set('n', '<Leader>1', function()  require("nvim-smartbufs").goto_buffer(1) end )
vim.keymap.set('n', '<Leader>2', function()  require("nvim-smartbufs").goto_buffer(2) end )
vim.keymap.set('n', '<Leader>3', function()  require("nvim-smartbufs").goto_buffer(3) end )
vim.keymap.set('n', '<Leader>4', function()  require("nvim-smartbufs").goto_buffer(4) end )
vim.keymap.set('n', '<Leader>5', function()  require("nvim-smartbufs").goto_buffer(5) end )
vim.keymap.set('n', '<Leader>6', function()  require("nvim-smartbufs").goto_buffer(6) end )
vim.keymap.set('n', '<Leader>7', function()  require("nvim-smartbufs").goto_buffer(7) end )
vim.keymap.set('n', '<Leader>8', function()  require("nvim-smartbufs").goto_buffer(8) end )
vim.keymap.set('n', '<Leader>9', function()  require("nvim-smartbufs").goto_buffer(9) end )
vim.keymap.set('n', '<Leader><Right>', function()  require("nvim-smartbufs").goto_next_buffer() end )
vim.keymap.set('n', '<Leader><Left>', function()  require("nvim-smartbufs").goto_prev_buffer() end )
vim.keymap.set('n', '<Leader>c1', function()  require("nvim-smartbufs").goto_terminal(1) end )
vim.keymap.set('n', '<Leader>c2', function()  require("nvim-smartbufs").goto_terminal(2) end )
vim.keymap.set('n', '<Leader>c3', function()  require("nvim-smartbufs").goto_terminal(3) end )
vim.keymap.set('n', '<Leader>c4', function()  require("nvim-smartbufs").goto_terminal(4) end )
vim.keymap.set('n', '<c-x>', function()  require("nvim-smartbufs").close_current_buffer() end )
vim.keymap.set('n', '<c-q>', function()  vim.api.nvim_command('q!') end )
vim.keymap.set('n', '<Leader>q1', function()  require("nvim-smartbufs").close_buffer(1) end )
vim.keymap.set('n', '<Leader>q2', function()  require("nvim-smartbufs").close_buffer(2) end )
vim.keymap.set('n', '<Leader>q3', function()  require("nvim-smartbufs").close_buffer(3) end )
vim.keymap.set('n', '<Leader>q4', function()  require("nvim-smartbufs").close_buffer(4) end )
vim.keymap.set('n', '<Leader>q5', function()  require("nvim-smartbufs").close_buffer(5) end )
vim.keymap.set('n', '<Leader>q6', function()  require("nvim-smartbufs").close_buffer(6) end )
vim.keymap.set('n', '<Leader>q7', function()  require("nvim-smartbufs").close_buffer(7) end )
vim.keymap.set('n', '<Leader>q8', function()  require("nvim-smartbufs").close_buffer(8) end )
vim.keymap.set('n', '<Leader>q9', function()  require("nvim-smartbufs").close_buffer(9) end )
vim.keymap.set('n', '<Leader>h', function() require("memento").toggle() end )

vim.keymap.set('n', '<Leader>ss', function() vim.api.nvim_command('SymbolsOutline') end)


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    require('coq')[ls].setup({
        capabilities = capabilities
        -- you can add other fields for setting up lsp server in this table
    })
end

-- Command Auto Completion
local wilder = require('wilder')
wilder.setup({
  modes = {':', '/', '?'},
  next_key = '<Down>',
  previous_key  = '<Up>',
  accept_key  = '<Tab>',
  reject_key = '<S-Tab>',

})
wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_palette_theme({
    -- 'single', 'double', 'rounded' or 'solid'
    -- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
    border = 'rounded',
    max_height = '75%',      -- max height of the palette
    min_height = 0,          -- set to the same as 'max_height' for a fixed height window
    prompt_position = 'top', -- 'top' or 'bottom' to set the location of the prompt
    reverse = 0,             -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
  })
))


-- COQ Config
vim.g.coq_settings = {
  auto_start = 'shut-up',
  ["display.icons.mode"] = 'none',
  ["limits.completion_auto_timeout"] = 0.2,
  ["limits.completion_manual_timeout"] = 1
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- set code runner
require('code_runner').setup({
  -- put here the commands by filetype
  filetype = {
		java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
		python = "python3 -u",
		typescript = "deno run",
		rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt"
	},
})

-- DAP Config
-- sudo pip3 install debugpy
local dap,dapui = require('dap'), require('dapui')

dapui.setup(
  {
    controls = {
      element = "repl",
      enabled = false,
      icons = {
        disconnect = "X",
        pause = "||",
        play = ">",
        run_last = "R",
        step_back = " ",
        step_into = "->",
        step_out = "~>",
        step_over = ">>",
        terminate = "Q"
      }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      collapsed = "-",
      current_frame = ">",
      expanded = "+"
    },
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.25
          }, {
            id = "breakpoints",
            size = 0.25
          }, {
            id = "stacks",
            size = 0.25
          }, {
            id = "watches",
            size = 0.25
          } },
        position = "left",
        size = 40
      }, {
        elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
        position = "bottom",
        size = 10
      } },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  }
)

dap.set_log_level('TRACE')
dap.adapters.python = {
  type = 'executable';
  command = '/usr/bin/python3';
  args = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    program = "${file}";
    pythonPath = function()
      return '/usr/bin/python3'
    end;
  },
}
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set('n', '<F5>', function()
  vim.api.nvim_command('write')
  require('dap').continue()
end, { desc = 'Debug Run Debug [F5]' })
vim.keymap.set('n', '<F6>', function() require('dap').step_over() end, { desc = 'Debug step over [F6]' })
vim.keymap.set('n', '<F7>', function() require('dap').step_into() end, { desc = 'Debug step into [F7]' })
vim.keymap.set('n', '<F8>', function() require('dap').step_out() end, { desc = 'Debug step out [F8]' })
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug toggle_breakpoint [F5]' })
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)


-- Mane
require('mini.map').setup()
MiniMap.config = {
  -- Highlight integrations (none by default)
  integrations = nil,

  -- Symbols used to display data
  symbols = {
    -- Encode symbols. See `:h MiniMap.config` for specification and
    -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
    -- Default: solid blocks with 3x2 resolution.
    encode = MiniMap.gen_encode_symbols.dot('4x2'),

    -- Scrollbar parts for view and line. Use empty string to disable any.
    scroll_line = '┃',
    scroll_view = ' ',
  },

  -- Window options
  window = {
    -- Whether window is focusable in normal way (with `wincmd` or mouse)
    focusable = false,

    -- Side to stick ('left' or 'right')
    side = 'right',

    -- Whether to show count of multiple integration highlights
    show_integration_count = true,

    -- Total width
    width = 10,

    -- Value of 'winblend' option
    winblend = 25,
  },
}
vim.keymap.set('n', '<Leader>m', MiniMap.toggle)



-- Debug UI
require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true }

})

-- empty setup using defaults
require("nvim-tree").setup({
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "none",
        highlight_modified = "none",
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        indent_markers = {
          enable = false,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = "before",
          modified_placement = "after",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = false,
            folder = false,
            folder_arrow = true,
            git = true,
            modified = true,
          },
          glyphs = {
            default = "*",
            symlink = "~",
            bookmark = "B",
            modified = "●",
            folder = {
              arrow_closed = "+",
              arrow_open = "-",
              default = "*",
              open = ">",
              empty = "?",
              empty_open = ">",
              symlink = "~",
              symlink_open = ">",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "U",
              renamed = "➜",
              untracked = "★",
              deleted = "D",
              ignored = "◌",
            },
          },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        symlink_destination = true,
      }
})

-- Theme 1 Config
-- require("bluloco").setup({
--   style = "auto",               -- "auto" | "dark" | "light"
--   transparent = false,
--   italics = false,
--   terminal = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
--   guicursor   = true,
-- })
-- End 

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})



-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
  sections = { lualine_b = { "%3{codeium#GetStatusString()}" } }
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
-- require('indent_blankline').setup {
--   char = '┊',
--   show_trailing_blankline_indent = false,
-- }
require("ibl").setup()

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch existing [B]uffers' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').commands, { desc = '[S]earch command' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- nvim tree
vim.keymap.set('n', '<C-e>', require('nvim-tree.api').tree.toggle, { desc = 'Toggle Nvim Tree' })
vim.keymap.set('n', '<leader>t', require('nvim-tree.api').tree.toggle, { desc = 'Toggle Nvim Tree' })

-- Exit for terminal
vim.api.nvim_command('tnoremap <Esc> <C-\\><C-n>')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vim' ,'vimdoc' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')


  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Top bar 
require('hardline').setup {
  bufferline = true,  -- disable bufferline
  bufferline_settings = {
    exclude_terminal = true,  -- don't show terminal buffers in bufferline
    show_index = true,        -- show buffer indexes (not the actual buffer numbers) in bufferline
  },
  theme = 'default',   -- change theme
  sections = {         -- define sections
    {class = 'mode', item = require('hardline.parts.mode').get_item},
    {class = 'high', item = require('hardline.parts.git').get_item, hide = 100},
    {class = 'med', item = require('hardline.parts.filename').get_item},
    '%<',
    {class = 'med', item = '%='},
    {class = 'low', item = require('hardline.parts.wordcount').get_item, hide = 100},
    {class = 'error', item = require('hardline.parts.lsp').get_error},
    {class = 'warning', item = require('hardline.parts.lsp').get_warning},
    {class = 'warning', item = require('hardline.parts.whitespace').get_item},
    {class = 'high', item = require('hardline.parts.filetype').get_item, hide = 60},
    {class = 'mode', item = require('hardline.parts.line').get_item},
  },
}

-- Turn on lsp status information
require('fidget').setup()

-- Symbols OutLine
local opts = {
  highlight_hovered_item = true,
  show_guides = true,
  auto_preview = false,
  position = 'right',
  relative_width = true,
  width = 25,
  auto_close = false,
  show_numbers = false,
  show_relative_numbers = false,
  show_symbol_details = true,
  preview_bg_highlight = 'Pmenu',
  autofold_depth = nil,
  auto_unfold_hover = true,
  fold_markers = { '+', '-' },
  wrap = false,
  keymaps = { -- These keymaps can be a string or a table for multiple keys
    close = {"<Esc>", "q"},
    goto_location = "<Cr>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    toggle_preview = "K",
    rename_symbol = "r",
    code_actions = "a",
    fold = "-",
    unfold = "=",
    fold_all = "_",
    unfold_all = "+",
    fold_reset = "R",
  },
  lsp_blacklist = {},
  symbol_blacklist = {},
  symbols = {
    File = { icon = "File", hl = "@text.uri" },
    Module = { icon = "Mod", hl = "@namespace" },
    Namespace = { icon = "Name", hl = "@namespace" },
    Package = { icon = "Pack", hl = "@namespace" },
    Class = { icon = "Class", hl = "@type" },
    Method = { icon = "Method", hl = "@method" },
    Property = { icon = ".", hl = "@method" },
    Field = { icon = "Field", hl = "@field" },
    Constructor = { icon = "", hl = "@constructor" },
    Enum = { icon = "Enum", hl = "@type" },
    Interface = { icon = "I", hl = "@type" },
    Function = { icon = "f", hl = "@function" },
    Variable = { icon = "v", hl = "@constant" },
    Constant = { icon = "c", hl = "@constant" },
    String = { icon = "s", hl = "@string" },
    Number = { icon = "n", hl = "@number" },
    Boolean = { icon = "b", hl = "@boolean" },
    Array = { icon = "a", hl = "@constant" },
    Object = { icon = "Obj", hl = "@type" },
    Key = { icon = "k", hl = "@type" },
    Null = { icon = "?", hl = "@type" },
    EnumMember = { icon = "", hl = "@field" },
    Struct = { icon = "𝓢", hl = "@type" },
    Event = { icon = "Evt", hl = "@type" },
    Operator = { icon = "+", hl = "@operator" },
    TypeParameter = { icon = "𝙏", hl = "@parameter" },
    Component = { icon = "", hl = "@function" },
    Fragment = { icon = "", hl = "@constant" },
  },
}


require("symbols-outline").setup(opts)



-- nvim-cmp setup
-- local cmp = require 'cmp'
-- local luasnip = require 'luasnip'

-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert {
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' },
--   },
-- }

-- Formatter
local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    json = { { "clang-format", "prettier" } },
  },
})

vim.api.nvim_create_user_command(
  'FormatDocuments',
  function() 
    conform.format({ lsp_fallback = true }) 
  end, 
  {bang = true, desc = "Format This Documents"}
)



-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
