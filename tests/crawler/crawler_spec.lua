local crawler = require("crawler")
local stub = require("luassert.stub")

describe("crawler", function()
  before_each(function()
    -- Reset the configuration before each test
    crawler.setup({
      render_markdown = true,
      render_json = false,
      search_engine = true,
    })
  end)

  after_each(function()
    print("vim.go.loadplugins status:", vim.go.loadplugins)
  end)

  describe("setup", function()
    it("works with default configuration", function()
      assert.are.same({
        render_markdown = true,
        render_json = false,
        search_engine = true,
      }, crawler.config)
    end)

    it("works with custom configuration", function()
      crawler.setup({
        render_markdown = false,
        render_json = true,
        search_engine = false,
      })
      assert.are.same({
        render_markdown = false,
        render_json = true,
        search_engine = false,
      }, crawler.config)
    end)
  end)

  describe("crawl", function()
    local mock_curl, mock_job, mock_vim

    before_each(function()
      mock_curl = {
        get = stub.new()
      }
      mock_job = {}
      mock_vim = {
        fn = {
          input = stub.new().returns("https://example.com"),
          shellescape = stub.new().returns("encoded_query"),
        },
        api = {
          nvim_buf_set_lines = stub.new(),
          nvim_get_current_buf = stub.new().returns(1),
          nvim_win_get_cursor = stub.new().returns({1, 0}),
        },
      }

      -- Replace global vim with our mock
      _G.vim = mock_vim

      -- Replace required modules with our mocks
      package.loaded["plenary.curl"] = mock_curl
      package.loaded["plenary.job"] = mock_job
    end)

    after_each(function()
      -- Restore original modules
      package.loaded["plenary.curl"] = nil
      package.loaded["plenary.job"] = nil
    end)

    it("processes a single URL correctly", function()
      mock_curl.get.returns({ status = 200, body = "Processed content" })

      crawler.crawl()

      assert.stub(mock_curl.get).was_called_with("r.jina.ai/https://example.com")
      assert.stub(mock_vim.api.nvim_buf_set_lines).was_called()
    end)

    it("handles multiple URLs", function()
      mock_vim.fn.input.returns("https://example.com, https://another.com")
      mock_curl.get.returns({ status = 200, body = "Processed content" })

      crawler.crawl()

      assert.stub(mock_curl.get).was_called(2)
      assert.stub(mock_vim.api.nvim_buf_set_lines).was_called(2)
    end)

    it("processes search queries", function()
      mock_vim.fn.input.returns("search query")
      mock_curl.get.returns({ status = 200, body = "Search results" })

      crawler.crawl()

      assert.stub(mock_curl.get).was_called_with("s.jina.ai/encoded_query")
      assert.stub(mock_vim.api.nvim_buf_set_lines).was_called()
    end)

    it("handles errors gracefully", function()
      mock_curl.get.returns({ status = 404, body = "Not found" })

      crawler.crawl()

      assert.stub(mock_vim.api.nvim_buf_set_lines).was_not_called()
    end)
  end)
end)

-- Print the status of vim.go.loadplugins at the end of all tests
print("Final vim.go.loadplugins status:", vim.go.loadplugins)