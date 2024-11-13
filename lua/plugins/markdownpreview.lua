
return {
   "iamcco/markdown-preview.nvim",
   config = function()
      vim.fn["mkdp#util#install"]()
      vim.g.mkdp_browser = "firefox"
   end,
   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
   ft = { "markdown" },
}
