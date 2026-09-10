-- Neovim 0.12+ requires nvim-treesitter `main` (the old `master` branch is frozen).
--
-- `main` builds every parser with the `tree-sitter` CLI (plus a C compiler), and it
-- installs them into stdpath("data")/site instead of the plugin directory. On a box
-- without the CLI the old config raised
--   Error during "tree-sitter build": ENOENT ... 'tree-sitter'
-- once per missing parser on every startup, so guard the install calls: no CLI means
-- one warning and highlighting for whatever parsers are already on the runtimepath.
local ensure_installed = {
  "bash",
  "c",
  "git_config",
  "git_rebase",
  "gitcommit",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "vim",
  "vimdoc",
}

local function has_cli()
  return vim.fn.executable("tree-sitter") == 1
end

local warned = false
local function warn_missing_cli(langs)
  if warned then
    return
  end
  warned = true
  vim.notify(
    ("nvim-treesitter: `tree-sitter` CLI not found on PATH, skipping parser install (%s).\n")
      :format(table.concat(langs, ", "))
      .. "macOS: `brew install tree-sitter`; Linux: `~/dotfiles/install.sh --install-apps`. Then `:TSUpdate`.",
    vim.log.levels.WARN
  )
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local max_filesize = 100 * 1024 -- 100 KB

    local installed = ts.get_installed("parsers")
    local missing = vim.tbl_filter(function(lang)
      return not vim.tbl_contains(installed, lang)
    end, ensure_installed)
    if #missing > 0 then
      if has_cli() then
        ts.install(missing)
      else
        warn_missing_cli(missing)
      end
    end

    local available ---@type string[]?
    local function is_available(lang)
      available = available or ts.get_available()
      return vim.tbl_contains(available, lang)
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
        if ok and stats and stats.size > max_filesize then
          return
        end

        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang then
          return
        end

        -- Parser already installed (site dir or any other runtimepath entry).
        if pcall(vim.treesitter.start, ev.buf, lang) then
          return
        end

        -- Otherwise install on demand, i.e. the old `auto_install = true`.
        if not is_available(lang) then
          return
        end
        if not has_cli() then
          warn_missing_cli({ lang })
          return
        end
        ts.install(lang):await(function(err)
          if err then
            return
          end
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
              pcall(vim.treesitter.start, ev.buf, lang)
            end
          end)
        end)
      end,
    })
  end,
}
