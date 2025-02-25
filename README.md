# crawler.nvim

A Neovim plugin for crawling web pages, rendering them to Markdown or JSON, and inserting the content into new buffers. It also supports asynchronous search functionality.

## Features

- Process single URLs, multiple URLs, or search queries
- Render web pages to Markdown or JSON
- Insert processed content into new Neovim buffers
- Supports visual selection or manual input
- Asynchronous search functionality
- Configurable options for rendering and search functionality

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'yourusername/crawler.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require("crawler").setup({
      -- Add any configuration options here (optional)
    })
  end,
}
```

## Configuration

You can configure the plugin by passing options to the `setup` function. The default configuration is:

```lua
require("crawler").setup({
  render_markdown = true,  -- Enable markdown rendering (default: true)
  render_json = true,      -- Enable JSON rendering (default: true)
  search_engine = true,    -- Enable search engine functionality (default: true)
})
```

## Usage

The plugin provides three main commands:

- `:CrawlMarkdown`: Crawl a URL and render it to Markdown
- `:CrawlJson`: Crawl a URL and render it to JSON
- `:CrawlSearch`: Perform an asynchronous search query

These commands can be used in normal mode (prompting for input) or visual mode (using the selected text as input).

### Default Key Mappings

The plugin comes with the following default key mappings:

- Normal mode:
  - `<leader>lm`: Crawl and render to Markdown
  - `<leader>lj`: Crawl and render to JSON
  - `<leader>ls`: Perform a search query

- Visual mode:
  - `<leader>lm`: Crawl selection and render to Markdown
  - `<leader>lj`: Crawl selection and render to JSON
  - `<leader>ls`: Search using selection

You can override these mappings in your Neovim configuration if desired.

### Examples:

1. Process a single URL and render to Markdown:
   ```
   :CrawlMarkdown
   > Enter URL or search query: https://example.com
   ```

2. Process multiple URLs and render to JSON:
   ```
   :CrawlJson
   > Enter URL or search query: https://example.com, https://another-example.com
   ```

3. Perform an asynchronous search:
   ```
   :CrawlSearch
   > Enter search query: neovim lua plugins
   ```
   The search will run in the background, and results will be displayed in a new buffer when ready.

4. Using visual mode:
   - Select a URL or text in visual mode
   - Press `<leader>lm` to crawl and render to Markdown
   - Press `<leader>lj` to crawl and render to JSON
   - Press `<leader>ls` to search using the selected text

## Behavior

- All crawled content and search results are opened in new buffers.
- Search queries are processed asynchronously, allowing you to continue working while waiting for results.

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

## Acknowledgements

This plugin would not be possible without the following projects:

- [yoheinakajima/jsondr](https://github.com/yoheinakajima/jsondr): A powerful tool for rendering JSON data, which is used in our JSON rendering functionality.
- [Jina Reader API](https://jina.ai/reader): The Jina Reader API is used for our Markdown rendering capabilities. For more information on how to use the Jina Reader API, please refer to their [documentation](https://jina.ai/reader).

We are grateful for these tools and APIs that have made crawler.nvim possible.
