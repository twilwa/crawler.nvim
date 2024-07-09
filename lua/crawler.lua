local curl = require('plenary.curl')
local job = require('plenary.job')

---@class Config
---@field render_markdown boolean
---@field render_json boolean
---@field search_engine boolean
local config = {
  render_markdown = true,
  render_json = true,
  search_engine = true,
}

---@class Crawler
local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

local function strip_protocol(url)
  return url:gsub("^https?://", "")
end

local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

local function process_url(url, render_type)
  local prefix, full_url
  local stripped_url = strip_protocol(url)
  if render_type == 'markdown' then
    prefix = 'https://r.jina.ai/'
    full_url = prefix .. stripped_url
  else
    prefix = 'https://jsondr.com/'
    full_url = prefix .. stripped_url
  end
  
  print("Fetching URL: " .. full_url)  -- Debug log
  
  local ok, response = pcall(curl.get, full_url)
  
  if not ok then
    print("Error making request: " .. tostring(response))
    return nil
  end
  
  print("Response status: " .. tostring(response.status))  -- Debug log
  if response.status ~= 200 then
    print("Warning: Non-200 status code received: " .. tostring(response.status))
  end

  if response.body then
    print("Response body length: " .. tostring(#response.body))  -- Debug log
    return response.body
  else
    print("Error: Empty response body")
    return nil
  end
end

local function insert_into_buffer(content)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, '\n'))
  vim.api.nvim_command('sbuffer ' .. buf)
end

local function process_sitemap(url)
  -- TODO: Implement sitemap processing
  print("Sitemap processing not yet implemented")
end

local function process_search(query)
  local search_url = 'https://s.jina.ai/' .. vim.fn.shellescape(query)
  
  job:new({
    command = "curl",
    args = { search_url },
    on_exit = function(j, return_val)
      if return_val == 0 then
        local result = table.concat(j:result(), "\n")
        vim.schedule(function()
          insert_into_buffer(result)
        end)
      else
        vim.schedule(function()
          print("Error performing search: " .. query)
        end)
      end
    end,
  }):start()

  print("Search in progress. Results will be displayed in a new buffer when ready.")
end

local function get_input(prompt)
  local input = vim.fn.mode() == 'v' and get_visual_selection() or ''
  if input == '' then
    input = vim.fn.input(prompt)
  end
  return input
end

local function crawl_with_type(render_type)
  local prompt = render_type == 'search' and "Enter search query: " or "Enter URL: "
  local input = get_input(prompt)

  if input == '' then
    print("No input provided")
    return
  end

  if input:find(',') then
    -- Multiple URLs
    for url in input:gmatch("[^,]+") do
      url = url:match("^%s*(.-)%s*$") -- Trim whitespace
      local content = process_url(url, render_type)
      if content then
        insert_into_buffer(content)
      else
        print("Failed to process URL: " .. url .. ". Please check that the URL exists.")
      end
    end
  elseif render_type == 'search' then
    -- Assume it's a search query
    if M.config.search_engine then
      process_search(input)
    else
      print("Search engine functionality is disabled")
    end
  else
    -- Single URL
    if input:match("sitemap%.xml$") then
      process_sitemap(input)
    else
      local content = process_url(input, render_type)
      if content then
        insert_into_buffer(content)
      else
        print("Failed to process URL: " .. input .. ". Please check that the URL exists.")
      end
    end
  end
end

M.crawl_markdown = function()
  crawl_with_type('markdown')
end

M.crawl_json = function()
  crawl_with_type('json')
end

M.crawl_search = function()
  crawl_with_type('search')
end

-- Set up the plugin commands
vim.api.nvim_create_user_command('CrawlMarkdown', M.crawl_markdown, {})
vim.api.nvim_create_user_command('CrawlJson', M.crawl_json, {})
vim.api.nvim_create_user_command('CrawlSearch', M.crawl_search, {})

-- Set up default keymaps
vim.api.nvim_set_keymap('n', '<leader>lm', ':CrawlMarkdown<CR>', { noremap = true, silent = true, desc = 'Crawl and render to Markdown' })
vim.api.nvim_set_keymap('n', '<leader>lj', ':CrawlJson<CR>', { noremap = true, silent = true, desc = 'Crawl and render to JSON' })
vim.api.nvim_set_keymap('n', '<leader>ls', ':CrawlSearch<CR>', { noremap = true, silent = true, desc = 'Perform a search query' })
vim.api.nvim_set_keymap('v', '<leader>lm', ':CrawlMarkdown<CR>', { noremap = true, silent = true, desc = 'Crawl selection and render to Markdown' })
vim.api.nvim_set_keymap('v', '<leader>lj', ':CrawlJson<CR>', { noremap = true, silent = true, desc = 'Crawl selection and render to JSON' })
vim.api.nvim_set_keymap('v', '<leader>ls', ':CrawlSearch<CR>', { noremap = true, silent = true, desc = 'Search using selection' })

return M