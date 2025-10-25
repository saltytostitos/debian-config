return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    -- Your minimal blueprint
    local custom_opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "branch" }, -- Git branch: Clean opener
        lualine_b = { "diff" }, -- Changes: Quick glance
        lualine_c = {
          "diagnostics",
          "tabs",
          {
            "buffers",
            symbols = { modified = "*" },
            use_mode_colors = true,
            buffers_color = { active = "lualine_a_normal" },
            mode = 2,
          },
        }, -- Empty: No path/diagnostics noise
        lualine_x = { "searchcount" }, -- Empty: Skip snacks/noice/dap clutter
        lualine_y = {
          {
            "filename",
            file_status = true,
            path = 1,
            shorting_target = 40,
            symbols = {
              modified = "*",
            },
          },
        },
        lualine_z = {
          {
            "filetype",
            colored = false,
            icon = { align = "right" },
            icon_only = true,
          },
        }, -- Filetype: Final icon punch
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    -- Merge: Your rules crush defaults
    opts = vim.tbl_deep_extend("force", opts or {}, custom_opts)

    -- Trouble: Slots into c (now empty, so it owns it if active)
    -- if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
    --   local trouble = require("trouble")
    --   local symbols = trouble.statusline({
    --     mode = "symbols",
    --     groups = {},
    --     title = false,
    --     filter = { range = true },
    --     format = "{kind_icon}{symbol.name:Normal}",
    --     hl_group = "lualine_c_normal",
    --   })
    --   table.insert(opts.sections.lualine_c, {
    --     symbols and symbols.get,
    --     cond = function()
    --       return vim.b.trouble_lualine ~= false and symbols.has()
    --     end,
    --   })
    -- end

    return opts
  end,
}
