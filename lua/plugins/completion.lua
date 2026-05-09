return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },
  term = {
    enabled = true,
    keymap = { preset = 'inherit' }, -- Inherits from top level `keymap` config when not set
    sources = {},
    completion = {
      trigger = {
        show_on_blocked_trigger_characters = {},
        show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
      },
      -- Inherits from top level config options when not set
      list = {
        selection = {
          -- When `true`, will automatically select the first item in the completion list
          preselect = nil,
          -- When `true`, inserts the completion item automatically when selecting it
          auto_insert = nil,
        },
      },
      -- Whether to automatically show the window when new completion items are available
      menu = { auto_show = nil },
      -- Displays a preview of the selected item on the current line
      ghost_text = { enabled = nil },
    }
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'default' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'Nerd Font Mono',
      highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = false,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
      kind_icons = {
        Text = '󰉿 ',
        Method = '󰊕 ',
        Function = '󰊕 ',
        Constructor = '󰒓 ',

        Field = '󰜢 ',
        Variable = '󰆦 ',
        Property = '󰖷 ',

        Class = '󱡠 ',
        Interface = '󱡠 ',
        Struct = '󱡠 ',
        Module = '󰅩 ',

        Unit = '󰪚 ',
        Value = '󰦨 ',
        Enum = '󰦨 ',
        EnumMember = '󰦨 ',

        Keyword = '󰻾 ',
        Constant = '󰏿 ',

        Snippet = '󱄽 ',
        Color = '󰏘 ',
        File = '󰈔 ',
        Reference = '󰬲 ',
        Folder = '󰉋 ',
        Event = '󱐋 ',
        Operator = '󰪚 ',
        TypeParameter = '󰬛 ',
      },
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { 
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      ghost_text = { enabled = true },
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 2 },
            { "kind_icon", "kind" }
          },
        },
        direction_priority = function()
          local ctx = require('blink.cmp').get_context()
          local item = require('blink.cmp').get_selected_item()
          if ctx == nil or item == nil then return { 's', 'n' } end

          local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
          local is_multi_line = item_text:find('\n') ~= nil

          -- after showing the menu upwards, we want to maintain that direction
          -- until we re-open the menu, so store the context id in a global variable
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { 'n', 's' }
          end
          return { 's', 'n' }
        end,
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
