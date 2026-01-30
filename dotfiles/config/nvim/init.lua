-- Syntax and filetype
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

-- Tab completion settings
vim.opt.wildmode = {'longest', 'list', 'full'}
vim.opt.wildmenu = true
vim.opt.path:append('**')

-- Indentation settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Move text and rehighlight
vim.keymap.set('v', '>', '><CR>gv')
vim.keymap.set('v', '<', '<<CR>gv')

-- Y mapping (neovim 0.7 compatibility)
vim.keymap.set('n', 'Y', 'Y')

-- FuzzyOpen
vim.keymap.set('n', '<C-p>', ':FuzzyOpen<CR>')

-- Color settings
vim.opt.termguicolors = false
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = '1'
vim.opt.background = 'dark'

-- System clipboard
vim.opt.clipboard = 'unnamedplus'

-- Move lines up/down
vim.keymap.set('n', '<C-Down>', ':m+<CR>')
vim.keymap.set('n', '<C-Up>', ':m-2<CR>')
vim.keymap.set('i', '<C-Down>', '<Esc>:m+<CR>')
vim.keymap.set('i', '<C-Up>', '<Esc>:m-2<CR>')
vim.keymap.set('v', '<C-Down>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<C-Up>', ":m '<-2<CR>gv=gv")

-- Custom commands
vim.api.nvim_create_user_command('Idate', ':r !date --iso-8601', {})
vim.api.nvim_create_user_command('Idatetime', ':r !date --iso-8601=seconds', {})
vim.api.nvim_create_user_command('Yfilepath', function() vim.fn.setreg('+', vim.fn.expand('%')) end, {})
vim.api.nvim_create_user_command('Yfilepathfull', function() vim.fn.setreg('+', vim.fn.expand('%:p')) end, {})
vim.api.nvim_create_user_command('Yfilename', function() vim.fn.setreg('+', vim.fn.expand('%:t')) end, {})

-- NERDCommenter setting
vim.g.NERDCompactSexyComs = 1

-- Line numbers
vim.opt.number = true
vim.cmd('highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE')

-- Status line
vim.opt.ruler = true
vim.opt.laststatus = 2

-- Buffer navigation
vim.keymap.set('n', '<C-j>', ':bn<CR>')
vim.keymap.set('n', '<C-k>', ':bp<CR>')

-- Preserve clipboard on exit
vim.api.nvim_create_autocmd('VimLeave', {
    pattern = '*',
    callback = function()
        vim.fn.system('echo ' .. vim.fn.shellescape(vim.fn.getreg('+')) .. ' | xclip -selection clipboard')
    end
})

-- Show tabs and trailing spaces
vim.opt.list = true
vim.opt.listchars = {tab = '>-', trail = '█'}

-- Plugin manager (vim-plug)
local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')

  -- Note I do not like Tokyonight (2026-01-30)
  Plug('wojciechkepka/vim-github-dark')


  -- Option 2: Catppuccin (soft, pleasant)
  Plug('catppuccin/nvim', { as = 'catppuccin' })
  -- Then use: vim.cmd('colorscheme catppuccin-mocha')

  -- Option 3: Gruvbox (classic, minimal)
  Plug('morhetz/gruvbox')
  -- Then use: vim.cmd('colorscheme gruvbox')

vim.call('plug#end')

-- Colorscheme
vim.cmd('colorscheme gruvbox')


-- Disable mouse
vim.opt.mouse = ''
