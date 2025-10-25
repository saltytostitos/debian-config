return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = { enabled = false },
      dim = { enabled = true },
    },
    keys = {
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>E", false },
      { "<leader>e", false },
    },
  },
}
