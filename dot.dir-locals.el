;; 如果没有安装lsp，或者需要禁用lsp，用gtags作索引时,在项目目录放入此文件。
;; 如果没有自动执行此文件，可以打开项目中的文件之前，需要先打开一下此文件。根据提示选"!"确认安全。
;; 然后再打开项目中的c文件，就可以在没有lsp的情况下用gtags作索引了
;; 注意：在打开项目下的一个.c文件触发执行了本文件后，需要关闭项目的.c文件，重新打开，才会正常。

;; 去掉打开.dir-locals.el文件时不安全提示
;; (setq enable-local-variables :all)


((nil . (
         (eval . (remove-hook 'c-mode-hook 'lsp))
         (eval . (remove-hook 'c-mode-hook 'helm-gtags-mode))
         (eval . (add-hook 'c-mode-hook 'helm-gtags-mode))
         ;; 重新绑定被lsp占用的快捷键给helm-gtags
         (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
         (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
         (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
         )
      ))

