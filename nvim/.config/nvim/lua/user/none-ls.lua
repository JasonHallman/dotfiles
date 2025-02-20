local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
}

function M.config()
  local null_ls = require "null-ls"

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  null_ls.setup {
    on_attach = function(client, bufnr)
      if client.supports_method "textDocument/formatting" then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { async = false }
          end,
        })
      end
    end,

    debug = false,
    sources = {
      formatting.stylua,
      formatting.prettier,
      -- diagnostics.ruff,
      -- formatting.ruff,
      -- formatting.black.with {
      --   extra_args = {
      --     "--line-length",
      --     "88",
      --     "--preview",
      --     "--enable-unstable-feature",
      --     "string_processing",
      --   },
      -- },
      -- null_ls.builtins.formatting.isort,
      require "none-ls.formatting.rustfmt",
      -- require("none-ls.diagnostics.flake8").with {
      --   extra_args = {
      --     "--max-line-length=88",
      --     "--ignore=E221",
      --   },
      -- },
      -- formatting.prettier.with {
      --   extra_filetypes = { "toml" },
      --   -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      -- },
      -- formatting.eslint,
      -- diagnostics.flake8.with {
      --   extra_args = {
      --     "--max-line-length=88",
      --     "--ignore=E221",
      --   }
      -- },
      -- null_ls.builtins.completion.spell,
    },
  }
end

return M
