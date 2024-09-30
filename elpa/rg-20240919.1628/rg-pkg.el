;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "rg" "20240919.1628"
  "A search tool based on ripgrep."
  '((emacs     "26.1")
    (transient "0.3.0")
    (wgrep     "2.1.10"))
  :url "https://github.com/dajva/rg.el"
  :commit "e9ca15dd113fc9690a56bef06b67c69ead414efd"
  :revdesc "e9ca15dd113f"
  :keywords '("matching" "tools")
  :authors '(("David Landell" . "david.landell@sunnyhill.email")
             ("Roland McGrath" . "roland@gnu.org"))
  :maintainers '(("David Landell" . "david.landell@sunnyhill.email")
                 ("Roland McGrath" . "roland@gnu.org")))
