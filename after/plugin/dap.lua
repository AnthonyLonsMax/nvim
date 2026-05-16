local mason_dap = require("mason-nvim-dap")
local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

-- Dap Virtual Text
dap_virtual_text.setup()

mason_dap.setup({
  ensure_installed = { "cppdbg" ,"delve","debugpy"},
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
	},
})

local function find_python()
  local venv = vim.fn.environ()["VIRTUAL_ENV"]
  if venv then
    local p = venv .. "/bin/python"
    if vim.fn.executable(p) == 1 then return p end
  end
  local cwd = vim.fn.getcwd()
  for _, dir in ipairs({ ".venv", "venv", ".env", "env" }) do
    local p = cwd .. "/" .. dir .. "/bin/python"
    if vim.fn.executable(p) == 1 then return p end
  end
  if vim.fn.executable("python3") == 1 then return "python3" end
  return "python3"
end

local function has_debugpy(python)
  return vim.fn.system(python .. " -c \"import debugpy; print('ok')\" 2>/dev/null"):match("ok")
end

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    local port = (config.connect or config).port
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    local python = find_python()
    if has_debugpy(python) then
      cb({
        type = 'executable',
        command = python,
        args = { "-m", "debugpy.adapter" },
        options = { source_filetype = 'python' },
      })
    else
      local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy"
      if vim.fn.isdirectory(mason_debugpy) == 1 then
        local mason_python = mason_debugpy .. "/venv/bin/python"
        if vim.fn.executable(mason_python) == 1 then
          cb({
            type = 'executable',
            command = mason_python,
            args = { "-m", "debugpy.adapter" },
            options = { source_filetype = 'python' },
          })
          return
        end
      end
      cb({
        type = 'executable',
        command = "debugpy",
        options = { source_filetype = 'python' },
      })
    end
  end
end

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.adapters.delve = function(callback, config)
    if config.mode == 'remote' and config.request == 'attach' then
        callback({
            type = 'server',
            host = config.host or '127.0.0.1',
            port = config.port or '38697'
        })
    else
        callback({
            type = 'server',
            port = '${port}',
            executable = {
                command = 'dlv',
                args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
                detached = vim.fn.has("win32") == 0,
            }
        })
    end
end

-- Configurations
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  -- works with go.mod packages and sub packages
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    program = "${file}";
    pythonPath = find_python;
  },
  {
    type = 'python';
    request = 'launch';
    name = "Debug pytest";
    program = function()
      return vim.fn.input('Path to test file: ', vim.fn.getcwd() .. '/', 'file')
    end;
    args = function()
      local test_path = vim.fn.input('Pytest args: ', '', 'file')
      return { "-m", "pytest", vim.fn.expand("%") .. (test_path ~= "" and "::" .. test_path or "") }
    end;
    pythonPath = find_python;
    cwd = "${workspaceFolder}";
  },
}

-- Dap UI

ui.setup()

vim.fn.sign_define("DapBreakpoint", { text = '🛑' })

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end



vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end)
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end)
vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)


vim.keymap.set('n', '<Leader>dq', function()
  require("dap").terminate()
  require("dapui").close()
  require("nvim-dap-virtual-text").toggle()
end)
