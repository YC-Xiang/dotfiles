-- Remove global default key mapping
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")

vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = true,
  float = { border = "rounded", source = "if_many" },
  update_in_insert = false,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local keymap = vim.keymap
		local lsp = vim.lsp
		local bufopts = { noremap = true, silent = true }

		keymap.set("n", "gd", lsp.buf.definition, bufopts)
		keymap.set("n", "gD", lsp.buf.declaration, bufopts)
		keymap.set("n", "gI", lsp.buf.implementation, bufopts)
		keymap.set("n", "gy", lsp.buf.type_definition, bufopts)
		keymap.set("n", "gr", lsp.buf.references, bufopts)
		keymap.set("n", "gh", lsp.buf.hover, bufopts)
		keymap.set("n", "K", lsp.buf.signature_help, bufopts)
		keymap.set("n", "<space>rn", lsp.buf.rename, {noremap = true, silent = true, desc = "lsp rename"})
		keymap.set("n", "<space>ca", lsp.buf.code_action, {noremap = true, silent = true, desc = "lsp code action"})
		keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
		keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
		keymap.set("n", "<space>fo", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, bufopts)
	end,
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		if #vim.diagnostic.get(vim.api.nvim_get_current_buf()) > 0 then
			vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
		end
	end,
})

vim.lsp.enable({ "clangd", "pyright" })
