;; 如果没有安装lsp，需要禁用lsp，用gtags作索引。
;; 在项目目录放入此文件。
;; 打开项目中的文件之前，需要先打开此文件。根据提示选"!"确认安全。
;; 然后再打开项目中的c文件，就可以在没有lsp的情况下用gtags作索引了

;; ;; 旧版本
;; ((nil . (
;;          ;; 如果没安装clangd，用这个方式禁用lsp-mode并没有效果
;;          (eval . (lsp-mode -1))
;;          (eval . (helm-gtags-mode 1))
;;          )
;;       ))

((nil . (
         (eval . (remove-hook 'c-mode-hook 'lsp))
         (eval . (remove-hook 'c-mode-hook 'helm-gtags-mode))
         (eval . (add-hook 'c-mode-hook 'helm-gtags-mode))
         )
      ))

