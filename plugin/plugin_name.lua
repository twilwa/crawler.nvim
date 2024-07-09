if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("crawler.nvim requires at least nvim-0.7.0")
  return
end

-- make sure this file is loaded only once
if vim.g.loaded_crawler == 1 then
  return
end
vim.g.loaded_crawler = 1

-- create any global command that does not depend on user setup
local crawler = require("crawler")

vim.api.nvim_create_user_command("Crawl", function(opts)
  crawler.crawl()
end, {})

-- Set up the key mapping
vim.api.nvim_set_keymap('n', '<leader>c', ':Crawl<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', ':Crawl<CR>', { noremap = true, silent = true })