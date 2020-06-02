"Copyright 2020 vimform7@gmail.com
"
"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
"
"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
"
"THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

function! inform#MAKETEST()
    :exec ":silent make"
    :redraw!
    term sh -c "~/.vimform7/Interpreters/dumb-glulxe ./Build/output.gblorb"
endfunction
noremap -7t :call inform#MAKETEST()<CR>
function! inform#Help()
    vert term sh -c "lynx -lss ~/.vimform7/Vimform7/lynx.lss ~/.vimform7/Documentation/index.html"
    wincmd w
endfunction
noremap -7h :call inform#Help()<CR>
function! inform#Play()
    term sh -c "~/.vimform7/Interpreters/dumb-glulxe ./Build/output.gblorb"
    wincmd w
endfunction
noremap -7p :call inform#Play()<CR>
function! inform#PlayHelp()
    vert term sh -c "~/.vimform7/Interpreters/dumb-glulxe ./Build/output.gblorb"
    term sh -c "lynx -lss ~/.vimform7/Vimform7/lynx.lss ~/.vimform7/Documentation/index.html"
    wincmd w
    wincmd w
endfunction
noremap -7ph :call inform#PlayHelp()<CR>
function! inform#GO()
    :!clear && ~/.vimform7/Interpreters/dumb-glulxe ./Build/output.gblorb
endfunction
noremap -g :call inform#GO()<CR>
function! inform#TEST()
    :make!
    :!clear && ~/.vimform7/Interpreters/dumb-glulxe ./Build/output.gblorb
endfunction
noremap -t :call inform#TEST()<CR>
function! inform#VIEW()
    :wincmd =
    :redraw!
endfunction
noremap -v :call inform#VIEW()<CR>
function! inform#LineDebug()
    :cexpr system('~/.local/bin/vimform7-compile-filter.sh')  |  copen
endfunction
"noremap -m :make!\|redraw!\|cc<CR>
noremap -f :make!<CR>\|<CR>
noremap -m :make!<CR>
noremap -d :term make<CR>
noremap -l :call inform#LineDebug()<CR>
noremap <t_F8> :call inform#TEST()<CR>
"noremap -l :cexpr system('./vimform7-compile.sh')  |  copen
