local actions = require('telescope.actions')
require('telescope').setup{
  defaults = { mappings = { i = { ["<esc>"] = actions.close } } }
}

lua require'telescope.builtin'.buffers{ show_all_buffers = true }

nnoremap <Leader><Tab> <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <Leader>f     <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>s     <cmd>lua require('telescope.builtin').live_grep()<CR>

nnoremap <Leader>tg    <cmd>lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>th    <cmd>lua require('telescope.builtin').help_tags()<CR>
nnoremap <Leader>tt    <cmd>lua require('telescope.builtin').treesitter()<CR>

nnoremap <Leader>lu    <cmd>lua require('telescope.builtin').lsp_references()<CR>
nnoremap <Leader>ld    <cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>
nnoremap <Leader>lw    <cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>
nnoremap <Leader>la    <cmd>lua require('telescope.builtin').lsp_code_actions()<CR>
