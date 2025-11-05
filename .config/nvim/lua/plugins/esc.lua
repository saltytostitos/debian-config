return {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup({
      timeout = 200, -- Lightning-fast bailout, with room for that coffee-spill tap
      mappings = {
        i = { -- Insert mode only—keeps it Vim-pure
          j = { -- Unlock the j-branch for jk magic
            k = "<Esc>", -- jk: Smooth home-row hop to freedom
          },
          k = { -- Unlock the k-branch for kj magic
            j = "<Esc>", -- kj: Quick pinky-home twist
          },
        },
      },
    })
  end,
}
