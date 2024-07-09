# crawler.nvim

A Neovim plugin for crawling web pages, rendering them to Markdown or JSON, and inserting the content directly into your buffer. It also supports search functionality.

## Features

- Process single URLs, multiple URLs, or search queries
- Render web pages to Markdown or JSON
- Insert processed content directly into your Neovim buffer
- Supports visual selection or manual input
- Configurable options for rendering and search functionality

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "yourusername/crawler.nvim",
  config = function()
    require("crawler").setup({
      -- Add any configuration options here
      render_markdown = true,
      render_json = false,
      search_engine = true,
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { "CrawlMarkdown", "CrawlJson", "CrawlSearch" },
}
```

## Configuration

You can configure the plugin by passing options to the `setup` function:

```lua
require("crawler").setup({
  render_markdown = true,  -- Enable markdown rendering
  render_json = false,     -- Enable JSON rendering
  search_engine = true,    -- Enable search engine functionality
})
```

## Usage

The plugin provides three main commands:

- `:CrawlMarkdown`: Crawl a URL and render it to Markdown
- `:CrawlJson`: Crawl a URL and render it to JSON
- `:CrawlSearch`: Perform a search query

You can use these commands in normal mode or visual mode (to use the selected text as input).

### Key Mappings

Add these to your Neovim configuration to set up key mappings:

```lua
vim.api.nvim_set_keymap('n', '<leader>cm', ':CrawlMarkdown<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cj', ':CrawlJson<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cs', ':CrawlSearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>cm', ':CrawlMarkdown<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>cj', ':CrawlJson<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>cs', ':CrawlSearch<CR>', { noremap = true, silent = true })
```

### Examples:

1. Process a single URL and render to Markdown:
   ```
   <leader>cm
   https://example.com
   ```

2. Process multiple URLs and render to JSON:
   ```
   <leader>cj
   https://example.com, https://another-example.com
   ```

3. Perform a search:
   ```
   <leader>cs
   neovim lua plugins
   ```

## Integration with Other Tools

crawler.nvim is particularly useful when used in conjunction with other plugins and tools that leverage Neovim buffers for various purposes:

### LLM Integration

- [aider.nvim](https://github.com/joshuavial/aider.nvim): Use crawler.nvim to fetch web content and feed it directly into aider.nvim for AI-assisted coding and documentation.
- [llm.nvim](https://github.com/huggingface/llm.nvim): Combine crawler.nvim with llm.nvim to pull web content and use it for generating or enhancing documentation with the power of large language models.

### Data Processing

- [glazed](https://github.com/go-go-golems/glazed): Use crawler.nvim to pull structured data from web pages, then process and transform this data using glazed CLI tools directly within Neovim.

These integrations allow you to seamlessly incorporate web content into your workflows, whether for documentation, data analysis, or AI-assisted development.

## Requirements

- Neovim >= 0.7.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.