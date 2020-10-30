autocmd FileType calendar nmap <silent> <buffer> <CR> :<C-u>call
  \ vimwiki#diary#calendar_action(b:calendar.day().get_day(),
  \ b:calendar.day().get_month(), b:calendar.day().get_year(),
  \ b:calendar.day().week(), "V")<CR>

nnoremap <Leader>c :Calendar<CR>

if match(readfile(google_calendar), "calendar") != -1
  execute 'source' google_calendar
endif

