
return {
  -- Hauptplugin für DAP-Unterstützung
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- Importiere nvim-dap
      local dap = require("dap")

      -- Definiere Zeichen für Breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

      -- Tastenkürzel für das Debuggen
      vim.api.nvim_set_keymap('n', '<Leader>dc', "<Cmd>lua require'dap'.continue()<CR>", { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>do', "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>di', "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>du', "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Bedingung: '))<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { noremap = true })

      -- C# Debugger-Konfiguration mit NetCoreDbg
      dap.adapters.coreclr = {
        type = "executable",
        command = "~/.local/share/nvim/dap/netcoredbg/netcoredbg", -- Pfad zu NetCoreDbg
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net7.0/", "file")
          end,
        },
      }
    end,
  },

  -- Erweiterung für Python-Debugging
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- Importiere nvim-dap-python
      local dap_python = require("dap-python")

      -- Richte dap-python mit dem Pfad zu deinem Python-Interpreter ein
      dap_python.setup("~/.virtualenvs/debugpy/bin/python")
    end,
  },

  -- Abhängigkeit: nvim-nio
  {
    "nvim-neotest/nvim-nio",
  },

  -- Benutzeroberfläche für DAP
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",  -- Füge nvim-nio als Abhängigkeit hinzu
    },
    config = function()
      -- Importiere und richte nvim-dap-ui ein
      require("dapui").setup()

      -- Automatisches Öffnen und Schließen der DAP-UI
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
      end
    end,
  },
}
