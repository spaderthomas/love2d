(load "~/quicklisp/setup.lisp")
(ql:quickload "cffi")
(let ((cffi:*foreign-library-directories* (list "~/source/lisp/sdl/")))
		   cffi:*foreign-library-directories*
  (ql:quickload "sdl2"))
