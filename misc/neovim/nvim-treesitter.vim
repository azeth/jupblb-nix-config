set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr
set foldlevel=5

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "bash", "c", "cpp", "java", "json", "nix", "python", "yaml" },
  indent = { enable = true },
  highlight = { enable = true }
}
EOF

