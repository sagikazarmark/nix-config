-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.colorscheme = "tokyonight"
-- lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "css",
  "dockerfile",
  "go",
  "graphql",
  "hcl",
  "gomod",
  "javascript",
  "json",
  "lua",
  "php",
  "rust",
  "toml",
  "typescript",
  "yaml",
  "vim",
  "nix",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- vim.list_extend(lvim.lsp.override, { "intelephense" })

-- local lsp_manager = require("lvim.lsp.manager");

-- local opts = {
--   -- cmd = {"/Users/marksk/.local/share/nvim/lsp_servers/php/node_modules/.bin/intelephense", "--stdio"},
--   cmd = {"/Users/marksk/Projects/misc/intelephense-debug/intelephense-debug"},
--   intelephense = {
--     format = {
--       enable = false
--     }
--   },
--   settings = {
--     intelephense = {
--       format = {
--         enable = false
--       }
--     },
--     format = {
--       enable = false
--     }
--   }
-- }
-- opts.settings["intelephense.format.enable"] = false
-- opts.settings.intelephense["format.enable"] = false
-- lsp_manager.setup("intelephense", opts)
-- require("lspconfig")["intelephense"].setup(opts)
-- lsp_manager.setup("rnix");
-- require("lspconfig")["rnix"].setup({})

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })
require("lvim.lsp.manager").setup("gopls", {
    cmd = { "gopls" }
})

require("lvim.lsp.manager").setup("rnix", {
    cmd = { "rnix-lsp" }
})

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "clang_format",
    filetypes = { "proto" },
    extra_args = {"--style", "{BasedOnStyle: Google, IndentWidth: 4}"},
  },

--   { exe = "black", filetypes = { "python" } },
--   { exe = "isort", filetypes = { "python" } },
--   {
--     exe = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "flake8", filetypes = { "python" } },
--   {
--     exe = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--severity", "warning" },
--   },
--   {
--     exe = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
  {"lunarvim/colorschemes"},
  {"folke/tokyonight.nvim"},
  {
      "ray-x/lsp_signature.nvim",
      config = function() require"lsp_signature".on_attach() end,
      event = "InsertEnter"
  },
  {
    "folke/trouble.nvim",
      cmd = "TroubleToggle",
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
  },
  {
    "ray-x/go.nvim",
    config = function() require('go').setup() end,
  },
  -- {"fatih/vim-go"},
  -- {
  --   "tpope/vim-surround",
  --   keys = {"c", "d", "y"}
  -- },
  -- {
  --   "blackCauldron7/surround.nvim",
  --   config = function()
  --     require"surround".setup {mappings_style = "surround"}
  --   end
  -- },
  {
    "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({ "*" }, {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            rgb_fn = true, -- CSS rgb() and rgba() functions
            hsl_fn = true, -- CSS hsl() and hsla() functions
            css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            })
    end,
  },
  {
    "wakatime/vim-wakatime"
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  {
    "vim-test/vim-test"
  },
  {
    "editorconfig/editorconfig-vim",
  },
  {
    "jbyuki/instant.nvim",
    config = function ()
      vim.g.instant_username = "mark"
    end
  },
  {
    "weilbith/nvim-code-action-menu"
  },
  {
    "kosayoda/nvim-lightbulb"
  },
  {
    "tridactyl/vim-tridactyl"
  },
  {
    "aklt/plantuml-syntax"
  },
  {
    "tyru/open-browser.vim"
  },
  {
    "weirongxu/plantuml-previewer.vim"
  },
  {
    "jjo/vim-cue"
  }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
  { "BufWinEnter", "*.php", "setlocal ts=4 sw=4" },
  { "BufWinEnter", "*.yaml.dist", "setlocal filetype=yaml" },
  { "BufWinEnter", "Makefile", "setlocal noexpandtab" },
}
