(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((define-key helm-gtags-mode-map
       (kbd "M-,")
       'helm-gtags-pop-stack)
     (define-key helm-gtags-mode-map
       (kbd "C-c >")
       'helm-gtags-next-history)
     (eval add-hook 'c-mode-hook 'helm-gtags-mode)
     (eval remove-hook 'c-mode-hook 'helm-gtags-mode)
     (eval remove-hook 'c-mode-hook 'lsp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
