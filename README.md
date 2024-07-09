# crawler.nvim

A Neovim plugin for crawling web pages and inserting their content into your buffer.

## Features

- Process single URLs, multiple URLs, or search queries
- Render web pages to Markdown or JSON
- Insert processed content directly into your Neovim buffer
- Supports visual selection or manual input
- Configurable options for rendering and search functionality

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'yourusername/crawler.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  }
}
```

## Configuration

Add the following to your Neovim configuration:

```lua
require('crawler').setup({
  render_markdown = true,  -- Set to false to disable markdown rendering
  render_json = false,     -- Set to true to enable JSON rendering
  search_engine = true,    -- Set to false to disable search engine functionality
})
```

## Usage

- In normal mode, press `<leader>c` and then enter a URL or search query when prompted.
- In visual mode, select text (URL or search query) and press `<leader>c`.
- Use the `:Crawl` command followed by a URL or search query.

### Examples:

1. Process a single URL:
   ```
   <leader>c
   https://example.com
   ```

2. Process multiple URLs:
   ```
   <leader>c
   https://example.com, https://another-example.com
   ```

3. Perform a search:
   ```
   <leader>c
   neovim lua plugins
   ```

## Requirements

- Neovim >= 0.7.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.