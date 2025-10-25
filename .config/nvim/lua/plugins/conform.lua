return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Keep defaults for other files (LazyVim merges these)
      lua = { "stylua" },
      -- Add more as needed, but skip markdown
      markdown = {}, -- Empty = no formatting
    },
  },
}
