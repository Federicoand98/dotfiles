require("notify").setup({
  stages = "fade_in_slide_out",
  on_open = nil,
  on_close = nil,
  render = "default",
  timeout = 5000,
  background_colour = "#000000",
  minimum_width = 50,
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎"
  }
})
vim.notify = require("notify")
