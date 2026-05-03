return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts = opts or require "nvchad.configs.telescope"
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        cache_picker = {
          num_pickers = 3, -- 保留最近几个 picker；-1 = 本会话全保留
          limit_entries = 2000, -- 每个 picker 最多缓存多少条结果
          ignore_empty_prompt = true, -- 空 prompt 就关的不进缓存
        },
      })
      return opts
    end,
  },
}
