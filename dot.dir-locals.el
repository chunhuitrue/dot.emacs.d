;; 如果没有安装lsp，或者需要禁用lsp，用gtags作索引时,在项目目录放入此文件。
;; 打开项目中的文件之前，需要先打开一下此文件。根据提示选"!"确认安全。
;; 然后再打开项目中的c文件，就可以在没有lsp的情况下用gtags作索引了

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

