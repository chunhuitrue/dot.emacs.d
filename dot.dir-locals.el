;; 如果没有安装lsp，需要禁用lsp，用gtags作索引。
;; 在项目目录放入此文件。
;; 打开项目中的文件之前，需要先打开此文件。根据提示选"!"确认安全。
;; 然后再打开项目中的c文件，就可以在没有lsp的情况下用gtags作索引了
((nil . (
         (eval . (remove-hook 'c-mode-hook 'lsp))
         (eval . (remove-hook 'c-mode-hook 'helm-gtags-mode))
         (eval . (add-hook 'c-mode-hook 'helm-gtags-mode))
         )
      ))

