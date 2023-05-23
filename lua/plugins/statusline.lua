return {
  -- feline status bar
  {
    "feline-nvim/feline.nvim",
    config = function()
      local feline = require("feline")
      local vi_mode_utils = require("feline.providers.vi_mode")
      local lsp = require("feline.providers.lsp")
      local icons = require("nvim-web-devicons")
      vim.opt.termguicolors = true

      local vi_mode_text = {
        NORMAL = " NORMAL ",
        OP = " OP ",
        INSERT = " INSERT ",
        VISUAL = " VISUAL ",
        LINES = " LINES ",
        BLOCK = " BLOCK ",
        REPLACE = " REPLACE ",
        ["V-REPLACE"] = " V-REPLACE ",
        ENTER = " ENTER ",
        MORE = " MORE ",
        SELECT = " SELECT ",
        COMMAND = " COMMAND ",
        SHELL = " SHELL ",
        TERM = " TERM ",
        NONE = " NONE ",
        CONFIRM = " CONFIRM ",
      }

      local force_inactive = {
        filetypes = {},
        buftypes = {},
        bufnames = {},
      }

      force_inactive.filetypes = {
        "packer",
        "Telescope",
      }

      force_inactive.buftypes = {
        "terminal",
      }

      local components = {
        active = { {}, {}, {} },
        inactive = { {}, {}, {} },
      }

      local colors = {
        bg = "#1f1d2e",
        black = "#191724",
        yellow = "#f6c177",
        cyan = "#31748f",
        oceanblue = "#31748f",
        green = "#9ccfd8",
        orange = "#ebbcba",
        violet = "#c4a7e7",
        magenta = "#eb6f92",
        white = "#e0def4",
        fg = "#e0def4",
        skyblue = "#9ccfd8",
        red = "#eb6f92",
      }

      local light_colors = {
        bg = "#fffaf3",
        black = "#faf4ed",
        yellow = "#ea9d34",
        cyan = "#286983",
        oceanblue = "#286983",
        green = "#56949f",
        orange = "#d7827e",
        violet = "#907aa9",
        magenta = "#b4637a",
        white = "#575279",
        fg = "#575279",
        skyblue = "#56949f",
        red = "#b4637a",
      }

      -- local colors = {
      --   bg = "#282828",
      --   black = "#282828",
      --   yellow = "#d8a657",
      --   cyan = "#89b482",
      --   oceanblue = "#45707a",
      --   green = "#a9b665",
      --   orange = "#e78a4e",
      --   violet = "#d3869b",
      --   magenta = "#c14a4a",
      --   white = "#a89984",
      --   fg = "#a89984",
      --   skyblue = "#7daea3",
      --   red = "#ea6962",
      -- }

      -- LEFT
      -- vi-mode
      components.active[1][1] = {
        hl = function()
          local val = {}

          val.bg = vi_mode_utils.get_mode_color()
          val.fg = "black"
          val.style = "bold"

          return val
        end,
        right_sep = " ",
      }

      -- vi-symbol
      components.active[1][2] = {
        provider = function() return vi_mode_text[vi_mode_utils.get_vim_mode()] end,
        hl = function()
          local val = {}

          val.fg = "bg"
          val.bg = vi_mode_utils.get_mode_color()
          val.style = "bold"

          return val
        end,
        right_set = " ",
      }

      -- filename
      components.active[1][3] = {
        provider = {
          name = "file_info",
          opts = {
            type = "relative-short",
            file_readonly_icon = "  ",
            file_modified_icon = "  ",
          },
        },
        hl = {
          fg = "white",
          bg = "bg",
          style = "bold",
        },
        right_sep = {
          str = " > ",
          hl = {
            fg = "white",
            bg = "bg",
            style = "bold",
          },
        },
        left_sep = " ",
      }

      -- git branch
      components.active[1][4] = {
        provider = "git_branch",
        hl = {
          fg = "magenta",
          bg = "bg",
          style = "bold",
        },
      }

      -- diffAdd
      components.active[1][5] = {
        provider = "git_diff_added",
        hl = {
          fg = "green",
          bg = "bg",
          style = "bold",
        },
      }
      -- diffModfified
      components.active[1][6] = {
        provider = "git_diff_changed",
        hl = {
          fg = "orange",
          bg = "bg",
          style = "bold",
        },
      }

      -- diffRemove
      components.active[1][7] = {
        provider = "git_diff_removed",
        hl = {
          fg = "red",
          bg = "bg",
          style = "bold",
        },
      }

      -- MIDDLE

      --[[ -- nvim-gps ]]
      --[[ components.active[2][1] = { ]]
      --[[   provider = function() ]]
      --[[     return gps.get_location() ]]
      --[[   end, ]]
      --[[   enabled = function() ]]
      --[[     return gps.is_available() ]]
      --[[   end, ]]
      --[[   hl = { ]]
      --[[     fg = "white", ]]
      --[[     bg = "bg", ]]
      --[[     style = "bold", ]]
      --[[   }, ]]
      --[[ } ]]

      -- diagnosticErrors
      components.active[2][1] = {
        provider = "diagnostic_errors",
        enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR) end,
        hl = {
          fg = "red",
          style = "bold",
        },
      }

      -- diagnosticWarn
      components.active[2][2] = {
        provider = "diagnostic_warnings",
        enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.WARN) end,
        hl = {
          fg = "yellow",
          style = "bold",
        },
      }

      -- diagnosticHint
      components.active[2][3] = {
        provider = "diagnostic_hints",
        enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.HINT) end,
        hl = {
          fg = "cyan",
          style = "bold",
        },
      }

      -- diagnosticInfo
      components.active[2][4] = {
        provider = "diagnostic_info",
        enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.INFO) end,
        hl = {
          fg = "skyblue",
          style = "bold",
        },
      }

      -- RIGHT

      -- lsp name
      components.active[3][1] = {
        provider = "lsp_client_names",
        enabled = true,
        icon = icons.lsp,
        hl = {
          fg = "yellow",
          bg = "bg",
          style = "bold",
        },
        right_sep = " ",
      }

      -- fileIcon
      components.active[3][2] = {
        provider = function()
          local filename = vim.fn.expand("%:t")
          local extension = vim.fn.expand("%:e")
          local icon = icons.get_icon(filename, extension)

          if icon == nil then icon = " " end

          return icon
        end,
        enabled = false,
        hl = function()
          local val = {}
          local filename = vim.fn.expand("%:t")
          local extension = vim.fn.expand("%:e")
          local icon, name = icons.get_icon(filename, extension)

          if icon ~= nil then
            val.fg = vim.fn.synIDattr(vim.fn.hlID(name), "fg")
          else
            val.fg = "white"
          end
          val.bg = "bg"
          val.style = "bold"

          return val
        end,
        right_sep = " ",
      }

      -- fileType
      components.active[3][3] = {
        provider = "file_type",
        enabled = false,
        hl = function()
          local val = {}
          local filename = vim.fn.expand("%:t")
          local extension = vim.fn.expand("%:e")
          local icon, name = icons.get_icon(filename, extension)

          if icon ~= nil then
            val.fg = vim.fn.synIDattr(vim.fn.hlID(name), "fg")
          else
            val.fg = "white"
          end
          val.bg = "bg"
          val.style = "bold"

          return val
        end,
        right_sep = " ",
      }

      -- fileSize
      components.active[3][4] = {
        provider = "file_size",
        enabled = false,
        hl = {
          fg = "skyblue",
          bg = "bg",
          style = "bold",
        },
        right_sep = " ",
      }

      -- fileformat
      components.active[3][5] = {
        provider = function() return "" .. vim.bo.fileformat .. "" end,
        enabled = false,
        hl = {
          fg = "white",
          bg = "bg",
          style = "bold",
        },
        right_sep = " ",
      }

      -- lineInfo
      components.active[3][6] = {
        provider = "position",
        hl = {
          fg = "white",
          bg = "bg",
          style = "bold",
        },
        right_sep = " ",
      }

      -- linePercent
      components.active[3][7] = {
        provider = "line_percentage",
        hl = {
          fg = "white",
          bg = "bg",
          style = "bold",
        },
        right_sep = " ",
      }

      -- scrollBar
      components.active[3][8] = {
        provider = "scroll_bar",
        hl = {
          fg = "yellow",
          bg = "bg",
        },
      }

      -- INACTIVE

      -- fileType
      components.inactive[1][1] = {
        provider = "file_type",
        hl = {
          fg = "black",
          bg = "cyan",
          style = "bold",
        },
        left_sep = {
          str = " ",
          hl = {
            fg = "NONE",
            bg = "cyan",
          },
        },
        right_sep = {
          {
            str = " ",
            hl = {
              fg = "NONE",
              bg = "cyan",
            },
          },
          " ",
        },
      }

      feline.setup({
        theme = colors,
        components = components,
        force_inactive = force_inactive,
      })
    end,
  },
}
