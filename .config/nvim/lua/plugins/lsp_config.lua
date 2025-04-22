return {
  -- Mason: Package manager for LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim", -- Add this to auto-install tools
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          -- LSP servers
          "pyright", -- Python
          "lua_ls",  -- Lua
          "intelephense", -- PHP
          "bashls",
          "dockerls",
          "docker_compose_language_service",
        },
        automatic_installation = true,
      })

      -- Ensure linters and formatters are installed
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Python
          "black",
          "isort",
          "flake8",
          "mypy",
          -- Lua
          "stylua",
          -- PHP
          "phpcbf",
          "php-cs-fixer",
          "phpstan",
          "phpcs",
          "beautysh",
          "shellcheck",
          "prettier",
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },

  -- LSP Config: Configure language servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local poetry = require("config.get_python_poetry_path")
      -- Python LSP (pyright) with Poetry support
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              autoImportCompletions = true,
              maxLineLength = 0,
            },
          },
        },
        before_init = function(_, config)
          local poetry_venv = poetry.get_python_poetry_path(config.root_dir)
          if poetry_venv then
            config.settings.python.pythonPath = poetry_venv
          end
        end,
      })

      -- Lua LSP
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- PHP LSP
      lspconfig.intelephense.setup({
        capabilities = capabilities,
        settings = {
          intelephense = {
            stubs = {
              "bcmath",
              "bz2",
              "calendar",
              "Core",
              "curl",
              "date",
              "dom",
              "fileinfo",
              "filter",
              "ftp",
              "gd",
              "gettext",
              "hash",
              "iconv",
              "imap",
              "intl",
              "json",
              "libxml",
              "mbstring",
              "mcrypt",
              "mysql",
              "mysqli",
              "password",
              "pcntl",
              "pcre",
              "PDO",
              "pdo_mysql",
              "Phar",
              "readline",
              "regex",
              "session",
              "SimpleXML",
              "sockets",
              "sodium",
              "standard",
              "superglobals",
              "tokenizer",
              "xml",
              "xmlreader",
              "xmlwriter",
              "zip",
              "zlib",
            },
            format = {
              enable = true,
            },
          },
        },
      })

      -- Bash Language server
      lspconfig.bashls.setup({
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash", "zsh" },
        root_dir = lspconfig.util.find_git_ancestor,
        single_file_support = true,
        settings = {
          bashIde = {
            -- Configure glob pattern for finding shell script files to analyze
            globPattern = "**/*.{sh,bash,zsh}",
            -- Enable/disable specific analysis features
            includeAllWorkspaceSymbols = true,
            -- Maximum number of completion items
            shellcheckPath = "", -- Auto-detect shellcheck path
            explainshellEndpoint = "", -- No explainshell integration by default
            -- Enable shellcheck if available
            enableSourceErrorDiagnostics = true,
            -- Format shell script on save
            formatOnSave = true,
            -- Analyze all files in the workspace
            shellcheckArguments = "",
          },
        },
      })
      lspconfig.dockerls.setup({
        cmd = { "docker-langserver", "--stdio" },
        filetypes = { "dockerfile" },
        root_dir = lspconfig.util.root_pattern(
          "Dockerfile",
          ".dockerignore",
          "docker-compose.yml",
          "docker-compose.yaml"
        ),
        single_file_support = true,
        settings = {
          docker = {
            languageserver = {
              diagnostics = {
                enable = true,
                deprecatedMaintainer = true,
                directiveCasing = true,
                emptyContinuationLine = true,
                instructionCasing = true,
                instructionCmdMultiple = true,
                instructionEntrypointMultiple = true,
                instructionHealthcheckMultiple = true,
                instructionJSONInSingleQuotes = true,
                instructionWorkdirRelative = true,
              },
              formatter = {
                enable = true,
              },
            },
          },
        },
      })
      lspconfig.docker_compose_language_service.setup({
        cmd = { "docker-compose-langserver", "--stdio" },
        filetypes = { "yaml.docker-compose" },
        root_dir = lspconfig.util.root_pattern(
          "docker-compose.yml",
          "docker-compose.yaml",
          "compose.yml",
          "compose.yaml"
        ),
        single_file_support = true,
        settings = {},
      })
      -- Global keymappings for LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, noremap = true, silent = true }
          -- See :help vim.lsp.* for documentation
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>lr", function()
            vim.lsp.buf_detach_client(0, vim.lsp.get_active_clients()[1].id) -- Detach
            vim.defer_fn(function()
              vim.cmd("edit")
            end, 100)
          end, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts) -- Location list
          vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts) -- Quickfix list
        end,
      })
    end,
  },

  -- null-ls for linting and formatting
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local function get_php_container_name()
        -- Get all running containers using `docker ps`
        local handle = io.popen("docker ps --filter 'name=php' --format '{{.Names}}'")
        local containers = handle:read("*a"):gsub("\n", " ")
        handle:close()

        -- Loop through each container and return the first one that is not phpmyadmin
        for container in containers:gmatch("%S+") do
          if not container:match("phpmyadmin") then
            return container -- Return the first PHP container that's not phpmyadmin
          end
        end

        -- If no valid PHP container found, return nil or a default value
        return nil
      end
      -- Get Mason's bin path to ensure tools are found
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

      null_ls.setup({
        -- Use Mason's path for executables
        cmd_env = {
          PATH = mason_bin .. ":" .. vim.env.PATH,
        },
        sources = {
          -- Python
          -- Formatting: black
          null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length", "88" },
          }),

          -- Formatting: isort
          null_ls.builtins.formatting.isort.with({
            extra_args = { "--profile", "black" }, -- Align isort with black's import sorting style
          }),

          -- Diagnostics: flake8
          null_ls.builtins.diagnostics.flake8.with({
            extra_args = { "--max-line-length", "88" }, -- Align flake8 with black's line length
          }),
          -- null_ls.builtins.diagnostics.mypy.with({
          --   command = mason_bin .. "mypy",
          -- }),

          -- Lua
          null_ls.builtins.formatting.stylua.with({
            command = mason_bin .. "stylua",
          }),
          -- null_ls.builtins.diagnostics.luacheck.with({
          -- 	command = mason_bin .. "luacheck",
          -- }),

          -- PHP
          -- PHP
          null_ls.builtins.formatting.phpcsfixer.with({
            command = mason_bin .. "php-cs-fixer",
            args = function(params)
              return {
                "fix",
                params.temp_path,
                "--config=" .. vim.fn.expand("/home/avt-dev-ia/.config/nvim/php-cs-fixer.php"), -- Point to a custom config file
              }
            end,
          }),
          null_ls.builtins.diagnostics.phpstan.with({
            command = "docker",
            args = function(params)
              return {
                "exec",
                get_php_container_name(),
                "/var/www/html/vendor/bin/phpstan", -- Using project's phpstan from vendor
                "analyze",
                "--level=5",
                "--no-progress",
                "--error-format=json",
                params.bufname, -- Use the actual file path
              }
            end,
          }),
          null_ls.builtins.diagnostics.php.with({
            command = "docker",
            args = {
              "exec",
              get_php_container_name(),
              "php",
              "-l",
              "$FILENAME",
            },
          }),
          null_ls.builtins.diagnostics.phpcs.with({
            command = mason_bin .. "phpcs",
          }),

          null_ls.builtins.formatting.phpcsfixer.with({
            command = "docker",
            args = function(params)
              local container_name = get_php_container_name() -- Get the container name using your function

              -- Base PHP CS Fixer command with Symfony rules
              local base_args = {
                "exec",
                "-i",
                container_name,
                "php-cs-fixer",
                "fix",
                "$FILENAME",
                "--rules=@Symfony",
                "--no-interaction",
                "--quiet",
              }

              -- Return the properly formatted arguments
              return base_args
            end,
            to_stdin = false, -- PHP CS Fixer doesn't support stdin processing
            to_temp_file = true, -- Write to a temp file since we're using $FILENAME
          }),
          -- bash
          null_ls.builtins.diagnostics.shellcheck.with({
            diagnostics_format = "[shellcheck] #{m} [#{c}]",
            extra_args = {
              "--severity=style", -- include style recommendations
              "--shell=bash", -- assume bash by default
              "--enable=all", -- enable all optional checks
              "--external-sources", -- allow 'source' ouside of FILES
              "--format=json", -- json output format for better parsing
            },
            filetypes = { "sh", "bash", "zsh" },
          }),

          -- Formatting
          null_ls.builtins.formatting.beautysh.with({
            extra_args = {
              "--indent-size",
              "2",
              "--force-function-style",
              "fnpar", -- function foo()
            },
            filetypes = { "sh", "bash", "zsh" },
          }),

          -- Additional bashls integration (code actions, hover, etc.)
          null_ls.builtins.code_actions.shellcheck.with({
            filetypes = { "sh", "bash", "zsh" },
          }),

          -- Optional: Hover for shell commands using explainshell
          -- Note: requires explainshell service running
          null_ls.builtins.hover.dictionary.with({
            filetypes = { "sh", "bash", "zsh" },
          }),

          -- YAML formatting with Prettier
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "yaml", "yml" },
            extra_args = {
              "--parser",
              "yaml",
              "--tab-width",
              "2",
              "--print-width",
              "120",
            },
          }),
          -- YAML diagnostics with yamllint
          null_ls.builtins.diagnostics.yamllint.with({
            filetypes = { "yaml", "yml" },
          }),
          -- JSON formatting with Prettier
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "json", "jsonc" },
            extra_args = {
              "--parser",
              "json",
              "--tab-width",
              "2",
              "--print-width",
              "120",
            },
          }),

          -- JSON diagnostics with JSON lint
          null_ls.builtins.diagnostics.jsonlint.with({
            filetypes = { "json", "jsonc" },
          }),
        },
      })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets", -- Preconfigured snippet collection
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local kind_icons = {
        Text = "",
        Method = "",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "󰀫",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "",
        File = "󰈙",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      }
      cmp.setup({
        formatting = {
          format = function(entry, vim_item)
            -- Add the icon before the kind
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
            -- Optional: customize menu labels
            vim_item.menu = ({
              buffer = "[Buf]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              path = "[Path]",
              nvim_lua = "[Lua]",
            })[entry.source.name]

            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
          }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
