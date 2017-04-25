" Commands for vim user
" Author Info Headers
command! AddHeader call header#add_header(0, 0)
command! AddMinHeader call header#add_header(1, 0)
" License Headers
command! AddMITLicense call header#add_header(2, 'mit')
command! AddApacheLicense call header#add_header(2, 'apache')
command! AddGNULicense call header#add_header(2, 'gnu')

" Set default global values
if !exists('g:header_auto_add_header') || g:header_auto_add_header == 1
    autocmd BufNewFile * :AddHeader
endif
