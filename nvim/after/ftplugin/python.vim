setlocal foldmethod=indent
setlocal textwidth=120
setlocal autoindent
setlocal fileformat=unix

iabbrev <buffer> #! #! /usr/bin/env python3
iabbrev <buffer> ifname if __name__ == "__main__":<cr>main()
