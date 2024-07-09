local curl = require('plenary.curl')
local job = require('plenary.job')

---@class Config
---@field render_markdown boolean
---@field render_json boolean
---@field search_engine boolean
local config = {
  render_markdown = true,
  render_json = false,
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

local function is_url(str)
  return str:match("^https?://") ~= nil
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
  local prefix = render_type == 'markdown' and 'r.jina.ai/' or 'jsondr.com/'
  local full_url = prefix .. url
  local response = curl.get(full_url)
  
  if response.status ~= 200 then
    print("Error fetching URL: " .. url)
    return nil
  end

  return response.body
end

local function insert_into_buffer(content)
  local current_buf = vim.api.nvim_get_current_buf()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(current_buf, current_line, current_line, false, vim.split(content, '\n'))
end

local function process_sitemap(url)
  -- TODO: Implement sitemap processing
  print("Sitemap processing not yet implemented")
end

local function process_search(query)
  local search_url = 's.jina.ai/' .. vim.fn.shellescape(query)
  local response = curl.get(search_url)
  
  if response.status ~= 200 then
    print("Error performing search: " .. query)
    return
  end

  insert_into_buffer(response.body)
end

local function crawl_with_type(render_type)
  local input = get_visual_selection()
  if input == '' then
    input = vim.fn.input("Enter URL, multiple URLs (comma-separated), or search query: ")
  end

  if input:find(',') then
    -- Multiple URLs
    for url in input:gmatch("[^,]+") do
      url = url:match("^%s*(.-)%s*$") -- Trim whitespace
      if is_url(url) then
        local content = process_url(url, render_type)
        if content then
          insert_into_buffer(content)
        end
      end
    end
  elseif is_url(input) then
    -- Single URL
    if input:match("sitemap%.xml$") then
      process_sitemap(input)
    else
      local content = process_url(input, render_type)
      if content then
        insert_into_buffer(content)
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
    print("Invalid input for " .. render_type .. " rendering")
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

return M