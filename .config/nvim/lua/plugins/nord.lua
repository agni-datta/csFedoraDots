return {
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    priority = 1000,
    lazy = false,
    opts = {
      borders = true,
      italics = {
        comments = true,
        keywords = false,
        functions = false,
        strings = false,
      },
      bold = true,
      contrast = true,      -- darker background for sidebars, floats
      disable_background = false,
      disable_float_background = false,
      cursorline = true,
    },
    config = function(_, opts)
      require("nord").set(opts)
      vim.cmd([[ colorscheme nord ]])
    end,
  },
}

