" PROPERTIES AND FUNCTIONS FOR GENERAL PURPOSES
" ---------------------------------------------
" Set default global values
if !exists('g:header_field_filename')
    let g:header_field_filename = 1
endif
if !exists('g:header_field_author')
    let g:header_field_author = ''
endif
if !exists('g:header_field_author_email')
    let g:header_field_author_email = ''
endif
if !exists('g:header_field_timestamp')
    let g:header_field_timestamp = 1
endif
if !exists('g:header_field_modified_timestamp')
    let g:header_field_modified_timestamp = 1
endif
if !exists('g:header_field_modified_by')
    let g:header_field_modified_by = 1
endif
if !exists('g:header_field_timestamp_format')
    let g:header_field_timestamp_format = '%d.%m.%Y'
endif
if !exists('g:header_cfg_comment_char')
    let g:header_cfg_comment_char = '#'
endif
if !exists('g:header_max_size')
    let g:header_max_size = 5
endif

" Path for license files directory
let s:license_files_dir = expand('<sfile>:p:h:h').'/licensefiles/'

" Sets values respect to buffer's filetype
fun s:set_props()
    " Variables for General Purposes
    let b:filetype = &ft
    let b:is_filetype_available = 1 " To check if filetype comment syntax is defined

    " Default Values for Many Languages
    let b:first_line = '' " If file type has initial line
    let b:first_line_pattern = ''
    let b:encoding = ''   " encoding
    let b:block_comment = 0 " If file type has block comment support
    let b:min_comment_begin = '' " If file type has a special char for minified versions
    let b:comment_char = '' " Comment char, or for block comment trailing char of body
    let b:auto_space_after_char = 1 " Put auto space after comment char, if line is not empty
    " Field placeholders according to doc comment syntax, if available
    let b:field_file = 'File:'
    let b:field_author = 'Author:'
    let b:field_date = 'Date:'
    let b:field_modified_date = 'Last Modified Date:'
    let b:field_modified_by= 'Last Modified By:'

    " Setting Values for Languages
    if
        \ b:filetype == 'c' ||
        \ b:filetype == 'cpp' ||
        \ b:filetype == 'css' ||
        \ b:filetype == 'groovy' ||
        \ b:filetype == 'java' ||
        \ b:filetype == 'scala' ||
        \ b:filetype == 'javascript' ||
        \ b:filetype == 'javascript.jsx' ||
        \ b:filetype == 'php' ||
        \ b:filetype == 'go' ||
        \ b:filetype == 'sass' ||
        \ b:filetype == 'rust'

        let b:block_comment = 1
        let b:comment_char = ' *'
        let b:comment_begin = '/**'
        let b:comment_end = ' */'
    " ----------------------------------
    elseif b:filetype == 'haskell'
        let b:block_comment = 1
        let b:comment_char = ' -'
        let b:comment_begin = '{-'
        let b:comment_end = ' -}'
    " ----------------------------------
    elseif b:filetype == 'lua'
        let b:auto_space_after_char = 0
        let b:block_comment = 1
        let b:comment_begin = '--[[--'
        let b:comment_end = '--]]--'
    " ----------------------------------
    elseif b:filetype == 'perl'
        let b:first_line = '#!/usr/bin/env perl'
        let b:first_line_pattern = '#!\s*/usr/bin/env\s* perl'
        let b:comment_char = '#'
    " ----------------------------------
    elseif b:filetype == 'python'
        let b:first_line = '#!/usr/bin/env python'
        let b:first_line_pattern = '#!\s*/usr/bin/env\s* python'
        let b:encoding = '# -*- coding: utf-8 -*-'
        let b:comment_char = '#'
    " ----------------------------------
    elseif b:filetype == 'sh'
        let b:first_line = '#!/bin/bash'
        let b:first_line_pattern = '#!\s*/bin/bash'
        let b:comment_char = '#'
    " ----------------------------------
    elseif b:filetype == "ruby" ||
          \ b:filetype == "elixir" ||
          \ b:filetype == "tmux"
        let b:comment_char = '#'
    " ----------------------------------
    elseif b:filetype == "erlang" ||
          \ b:filetype == "plaintex"
        let b:comment_char = "%%"
    " ----------------------------------
    elseif b:filetype == 'vim'
        let b:comment_char = '"'
    " ----------------------------------
    elseif b:filetype == "lisp" ||
          \ b:filetype == "scheme" ||
          \ b:filetype == "asm" ||
          \ b:filetype == "clojure"
        let b:comment_char = ";;"
    " ----------------------------------
    elseif b:filetype == "cs"
        let b:comment_char = "//"
    " ----------------------------------
    elseif b:filetype == "xdefaults"
        let b:comment_char = "!!"
    " ----------------------------------
    elseif b:filetype == "ocaml"
        let b:comment_begin = "(**"
        let b:comment_end = "*)"
        let b:comment_char = "*"
        let b:block_comment = 1
    " ----------------------------------
    elseif b:filetype == 'html'
        let b:first_line = '<!DOCTYPE html>'
        let b:first_line_pattern = '<!DOCTYPE\s* html>'
        let b:block_comment = 1
        let b:comment_char = ' -'
        let b:comment_begin = '<!--'
        let b:comment_end = '-->'
    "-----------------------------------
    elseif b:filetype == 'pug'
        let b:first_line = '//-'
        let b:first_line_pattern = '//-'
        let b:comment_char = ' '
    " ----------------------------------
    elseif b:filetype == 'octave' ||
          \ b:filetype == 'matlab'
        let b:comment_char = '%'
    " ----------------------------------
    elseif b:filetype == 'cfg'
        let b:comment_char = g:header_cfg_comment_char
    " ----------------------------------
    else
        let b:is_filetype_available = 0
    endif

    " Individual settings for special cases
    if b:filetype == 'php'
        let b:first_line = '<?php'
        let b:first_line_pattern = '<?php'
        let b:field_author = '@author'
    endif
    if b:filetype == 'css'
        let b:min_comment_begin = '/*!'
    endif
    if
        \ b:filetype == 'javascript' ||
        \ b:filetype == 'javascript.jsx'

        let b:min_comment_begin = '/*!'
        let b:field_file = '@file'
        let b:field_author = '@author'
    endif

    " For license texts, if there is a empty line, avoid trailing white space
    let b:comment_char_wo_space = b:comment_char
    " If there is space after comment char, put it
    if b:auto_space_after_char
        let b:comment_char .= ' '
    endif
endfun

" HEADER GENERATORS
" -----------------
" Generate Header
fun s:add_header()
    let l:save_pos = getpos(".")
    let l:i = 0

    " If filetype has initial line
    if b:first_line != ''
        let l:line = search(b:first_line_pattern)
        if l:line == 0
            call append(l:i, b:first_line)
            let l:i += 1
        else
            let l:i = l:line
        endif
    endif
    " if has encoding
    if b:encoding != ''
        call append(l:i, b:encoding)
        let l:i += 1
    endif
    " If filetype supports block comment, open comment
    if b:block_comment
        call append(l:i, b:comment_begin)
        let l:i += 1
    endif

    " Fill user's information
    if g:header_field_filename
        call append(l:i, b:comment_char . b:field_file . ' ' . expand('%s:t'))
        let l:i += 1
    endif
    if g:header_field_author != ''
        if g:header_field_author_email != ''
            let l:email = ' <' . g:header_field_author_email . '>'
        else
            let l:email = ''
        endif
        call append(l:i, b:comment_char . b:field_author . ' ' . g:header_field_author . l:email)
        let l:i += 1
    endif
    if g:header_field_timestamp
        call append(l:i, b:comment_char . b:field_date . ' ' . strftime(g:header_field_timestamp_format))
        let l:i += 1
    endif
    if g:header_field_modified_timestamp
        call append(l:i, b:comment_char . b:field_modified_date . ' ' . strftime(g:header_field_timestamp_format))
        let l:i += 1
    endif
    if g:header_field_modified_by && g:header_field_author != ''
        if g:header_field_author_email != ''
            let l:email = ' <' . g:header_field_author_email . '>'
        else
            let l:email = ''
        endif
        call append(l:i, b:comment_char . b:field_modified_by . ' ' . g:header_field_author . l:email)
        let l:i += 1
    endif

    " If filetype supports block comment, close comment
    if b:block_comment
        call append(l:i, b:comment_end)
    endif
    call setpos(".", l:save_pos)
endfun

" This will replace characters which needs to be escaped in patterns
fun s:create_pattern_text(text)
    let patterns = [['\*', '\\\*', ''],['\.', '\\\.', ''],['@', '\\@', ''],[ '"', '\\"', ''],[ '/', '\\/', 'g']]
    let l:res = a:text
    for p in patterns
        let l:res = substitute(l:res, p[0], p[1], p[2])
    endfor
    return l:res
endfun

" Update header field with the new value
fun s:update_header_field(field, value)
    let l:field = s:create_pattern_text(a:field) . '\s*.*'
    let l:field_add = s:create_pattern_text(a:field) . ' '
    execute '%s/' . l:field . '/' . l:field_add . s:create_pattern_text(a:value) .'/'
endfun

" Update Header
fun s:update_header()
    let l:save_pos = getpos(".")
    " Update file name
    if g:header_field_filename
        call s:update_header_field(b:field_file, expand('%s:t'))
    endif
    "" Update last modified date
    if g:header_field_modified_timestamp
        call s:update_header_field(b:field_modified_date, strftime(g:header_field_timestamp_format))
    endif
    "" Update last modified author
    if g:header_field_modified_by && g:header_field_author != ''
        if g:header_field_author_email != ''
            let l:email = ' <' . g:header_field_author_email . '>'
        else
            let l:email = ''
        endif
        call s:update_header_field(b:field_modified_by, g:header_field_author . l:email)
    endif
    "echo 'Header was updated succesfully.'
    call setpos(".", l:save_pos)
endfun

" Generate Minified Header
fun s:add_min_header()
    let l:save_pos = getpos(".")
    let l:i = 0

    " If filetype has initial line
    if b:first_line != ''
        let l:line = search(b:first_line_pattern)
        if l:line == 0
            call append(l:i, b:first_line)
            let l:i += 1
        else
            let l:i = l:line
        endif
    endif

    if b:encoding != ''
        call append(l:i, b:encoding)
        let l:i += 1
    endif

    " Set comment open char
    if b:block_comment
        if b:min_comment_begin == ''
            let l:header_line = b:comment_begin
        else
            let l:header_line = b:min_comment_begin
        endif
    else
        let l:header_line = b:comment_char
    endif

    " Fill user's information
    if g:header_field_filename
        let l:header_line .= ' ' . expand('%s:t')
    endif
    if g:header_field_author != ''
        if g:header_field_author_email != ''
            let l:email = ' <' . g:header_field_author_email . '>'
        else
            let l:email = ''
        endif
        let l:header_line .= ' ' . b:field_author . ' "' . g:header_field_author . l:email . '"'
    endif
    if g:header_field_timestamp
        let l:header_line .= ' ' . b:field_date . ' ' . strftime(g:header_field_timestamp_format)
    endif

    " If filetype supports block comment, close comment
    if b:block_comment
        let l:header_line .= ' ' . b:comment_end
    endif

    " Add line to file
    call append(l:i, l:header_line)
    call setpos(".", l:save_pos)
endfun

" Generate License Header
fun s:add_license_header(license_name)
    let l:save_pos = getpos(".")
    " Add other infos
    let l:i = 0

    " If filetype has initial line
    if b:first_line != ''
        let l:line = search(b:first_line_pattern)
        if l:line == 0
            call append(l:i, b:first_line)
            let l:i += 1
        else
            let l:i = l:line
        endif
    endif

    if b:encoding != ''
        call append(l:i, b:encoding)
        let l:i += 1
    endif

    " If filetype supports block comment, open comment
    if b:block_comment
        call append(l:i, b:comment_begin)
        let l:i += 1
    endif

    " Fill user's information
    if g:header_field_filename
        call append(l:i, b:comment_char . expand('%s:t'))
        let l:i += 1
    endif
    if g:header_field_author != ''
        if g:header_field_author_email != ''
            let l:email = ' <' . g:header_field_author_email . '>'
        else
            let l:email = ''
        endif
        call append(l:i, b:comment_char . 'Copyright (c) ' . strftime('%Y') . ' ' . g:header_field_author . l:email)
        call append(l:i+1, b:comment_char_wo_space)
        let l:i += 2
    endif

    " Path to license file
    let l:file_name = s:license_files_dir . a:license_name
    " If license file is not exists, inform user
    if !filereadable(l:file_name)
        echo 'There is no defined "' . a:license_name . '" license.'
        return
    endif

    " Add raw license, and count lines of it
    let l:license_line_count = -line('$')
    execute expand(l:i) . 'read ' . expand(l:file_name)
    let l:license_line_count += line('$')

    let l:i += 1
    let l:license_line_count += l:i
    " Take raw license into comment
    while l:i < l:license_line_count
        let l:line = getline(l:i)
        " If there is an empty line, avoid putting trailing space
        if l:line == ''
            let l:line = b:comment_char_wo_space
        else
            let l:line = b:comment_char . l:line
        endif

        call setline(l:i,l:line)
        let l:i += 1
    endwhile

    " If filetype supports block comment, close comment
    if b:block_comment
        call append(l:i - 1, b:comment_end)
        let l:i += 1
    endif

    call setpos(".", l:save_pos)
endfun

" Check if required headers (ones that are set globally as required)
" are present from the start of the buffer to the header_size_threshold.
" ----------------------------------------------------------------------
" returns 1 if all required headers are present and within the range,
" otherwise returns 0
fun s:has_required_headers_in_range(header_size_threshold)
    let l:save_pos = getpos(".")
    let l:headers_fields = [] " list holding required headers

    " File header
    if g:header_field_filename
        call add(l:headers_fields, b:field_file)
    endif

    " Author header
    if g:header_field_author != ''
        call add(l:headers_fields, b:field_author)
    endif

    " Date header
    if g:header_field_timestamp
        call add(l:headers_fields, b:field_date)
    endif

    " Last Modified Date header
    if g:header_field_modified_timestamp
        call add(l:headers_fields, b:field_modified_date)
    endif

    " Last Modified By header
    if g:header_field_modified_by
        call add(l:headers_fields, b:field_modified_by)
    endif

    " check if required headers are present and within the range
    for l:header_field in l:headers_fields
        let l:header_field_line_nbr = search(l:header_field)
        if
            \ l:header_field_line_nbr == 0 ||
            \ l:header_field_line_nbr > a:header_size_threshold
            call setpos(".", l:save_pos)
            return 0
        endif
    endfor
    call setpos(".", l:save_pos)
    return 1
endfun
"
" MAIN FUNCTION
" -------------
" Main function selects header generator to add header
" type parameter options;
"   0: Normal Header
"   1: Minified Header
"   2: License Header (also uses license parameter)
fun header#add_header(type, license, silent)
    call s:set_props()

    " If filetype is available, add header else inform user
    if b:is_filetype_available

        let l:file_contains_headers =
            \ s:has_required_headers_in_range(g:header_max_size)

        " Select header generator
        if a:type == 0
            " If there is already header, update it
            if l:file_contains_headers
                call s:update_header()
            else
                call s:add_header()
            endif
        elseif a:type == 1
            call s:add_min_header()
        elseif a:type == 2
            call s:add_license_header(a:license)
        else
            echo 'There is no "' . a:type . '" type to add header.'
        endif

    else
        if a:silent == 1
            return
        endif

        if b:filetype == ''
            let l:filetype = 'this'
        else
            let l:filetype = '"' . b:filetype . '"'
        endif
        echo 'No defined comment syntax for ' . l:filetype . ' filetype.'
    endif
endfun
