((nil . (
         ;; 如果没安装clangd，用这个方式禁用lsp-mode并没有效果
         (eval . (lsp-mode -1))
         (eval . (helm-gtags-mode 1))
         )
      ))

