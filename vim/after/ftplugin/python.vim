setlocal foldmethod=indent
setlocal textwidth=120
setlocal autoindent
setlocal fileformat=unix

iabbrev <buffer> #! #! /usr/bin/env python3
iabbrev <buffer> #!p #! /usr/bin/env python
iabbrev <buffer> #!2 #! /usr/bin/env python2
iabbrev <buffer> #!3 #! /usr/bin/env python3
iabbrev <buffer> ifname if __name__ == "__main__":<cr>main()
