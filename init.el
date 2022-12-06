;; This is to support loading from a non-standard .emacs.d
;; via emacs -q --load "/path/to/standalone.el"
;; see https://emacs.stackexchange.com/a/4258/22184


(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; (add-to-list 'load-path "~/.emacs.d/site-lisp") 


(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; ;; elpa国内镜像
;; ;; https://mirrors.tuna.tsinghua.edu.cn/help/elpa/
;; (setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;                          ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(setq package-user-dir (expand-file-name "elpa/" user-emacs-directory))
(package-initialize)

;; Install use-package that we require for managing all other dependencies
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(load-theme 'tango-dark t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq recentf-max-saved-items 10
      inhibit-startup-message t
      ring-bell-function 'ignore)
(recentf-mode 1)
(tool-bar-mode 0)
(menu-bar-mode 0)
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode 0))
(column-number-mode t)
(which-function-mode t)
(electric-pair-mode t)
;; (setq word-wrap-by-category t)             ;按照中文折行


;; 平滑地进行半屏滚动，避免滚动后recenter操作
(setq scroll-step 1
      scroll-conservatively 10000)


;; ;; 不太好使。ec之后仍然会出现，一切换到其他buff之后才关闭scratch
;; ;; 不显示 *scratch*
;; (defun remove-scratch-buffer ()
;;   (if (get-buffer "*scratch*")
;;       (kill-buffer "*scratch*")))
;; (add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)


;; 自动保存
;; (setq auto-save-default nil)
;; (setq undo-tree-auto-save-history nil)


;; 自动备份
(setq make-backup-files nil)
;; (setq backup-directory-alist '(("." . "~/.emacs_backups"))) ; emacs自动备份文件存入特定目录


(define-key global-map (kbd "M-o") 'other-window)
(define-key global-map (kbd "M-p") 'backward-paragraph) ; 跳到段落空行
(define-key global-map (kbd "M-n") 'forward-paragraph)
(define-key global-map (kbd "C-x C-a") 'align)


(setq comment-style 'extra-line)       ;多行注释
;; (define-key global-map (kbd "M-;") 'comment-line)     ; 多行注释
;; (define-key global-map (kbd "C-x C-m") 'comment-dwim) ; 单行行尾注释
(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and
we are not at the end of the line, then comment current line.
Replaces default behaviour of comment-dwim,
when it inserts comment at the end of the line. "
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'qiang-comment-dwim-line)


;; 字体
;; (cond
;;  ((member "Monaco" (font-family-list))
;;   (set-face-attribute 'default nil :font "Monaco-12"))
;;  ((member "Inconsolata" (font-family-list))
;;   (set-face-attribute 'default nil :font "Inconsolata-12"))
;;  ((member "Consolas" (font-family-list))
;;   (set-face-attribute 'default nil :font "Consolas-11"))
;;  ((member "DejaVu Sans Mono" (font-family-list))
;;   (set-face-attribute 'default nil :font "DejaVu Sans Mono-10")))


;; 精简mode-line上显示的minor-mode
;; https://elpa.gnu.org/packages/delight.html
;; https://jwiegley.github.io/use-package/keywords/#diminish-delight
(use-package delight
  :ensure
  :config
  ;; (delight 'abbrev-mode " Abv" "abbrev") ; 替换显示的字符串
  (delight 'abbrev-mode nil "abbrev")
  (delight 'eldoc-mode nil "ElDoc")
  )


(use-package which-key
  :ensure
  :delight which-key-mode  
  :init
  (which-key-mode))


(use-package golden-ratio
  :ensure
  :delight golden-ratio-mode
  :init
  (golden-ratio-mode)
  )


(use-package yasnippet
  :ensure
  :delight yas-minor-mode
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode)
  )

(use-package yasnippet-snippets
  :ensure
  )


(use-package company
  :ensure
  :delight company-mode
  :bind
  (:map company-active-map
              ("C-n". company-select-next)
              ("C-p". company-select-previous)
              ("M-<". company-select-first)
              ("M->". company-select-last))
  (:map company-mode-map
        ("<tab>". tab-indent-or-complete)
        ("TAB". tab-indent-or-complete))
  )

(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))


(use-package flycheck
  :ensure
  )


(use-package json-mode
  :ensure
  :config
  (add-hook 'json-mode-hook #'flycheck-mode)
  (add-hook 'json-mode-hook #'company-mode)  
  )


(use-package magit
  :ensure
  )


(use-package helm
  :ensure
  :config
  (define-key global-map (kbd "C-c o") 'helm-occur) ; 和helm-gtags查找系列一致的前缀
  (define-key global-map (kbd "C-x C-b") 'helm-mini)
  (define-key global-map (kbd "M-y") 'helm-show-kill-ring)

  ;; 让helm的窗口显示在下方
  ;; ;; 固定选用 bottom 的窗口
  ;; (add-to-list 'display-buffer-alist
  ;;              '("^\\*helm .*"
  ;;                (display-buffer-at-bottom)))
  ;; 用 side window
  (add-to-list 'display-buffer-alist
               '("^\\*helm .*"
                 (display-buffer-in-side-window)
                 (side . bottom)))
  )


(use-package lsp-treemacs :ensure)


(use-package helm-rg
  :ensure
  :config
  (setq helm-rg-candidate-limit 2000)
  )


(use-package helm-xref
  :ensure
  :config
  (define-key global-map [remap find-file] #'helm-find-files)
  (define-key global-map [remap execute-extended-command] #'helm-M-x)
  (define-key global-map [remap switch-to-buffer] #'helm-mini)
  )


;; https://github.com/bbatsov/helm-projectile
;; https://tuhdo.github.io/helm-projectile.html
(use-package helm-projectile
  :ensure t
  :init
  ;; (helm-projectile-on)
  )


;; https://docs.projectile.mx/projectile/configuration.html
(use-package projectile
  :ensure t
  :delight '(:eval (concat " " (projectile-project-name)))
  :init
  (projectile-mode +1)
  :config
  (projectile-global-mode)
  (helm-projectile-on)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'helm)
  (setq projectile-switch-project-action 'helm-projectile)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  )


(use-package cc-mode
  :ensure
  :config (setq-default
           indent-tabs-mode nil          ; indent. 用 tab: t  用空格: nil
           tab-width 4                   ; tab宽度
           c-basic-offset 4              ; 缩进的基本单位，2字符，4字符等
           c-default-style "linux"       ; c 缩进风格. M-x c-set-style 选择当前文件的风格
           )
  )


(use-package helm-gtags
  :ensure
  :delight helm-gtags-mode  
  :config
  (with-eval-after-load 'helm-gtags
    (setq helm-gtags-path-style 'relative)
    (setq helm-gtags-ignore-case t)
    (setq helm-gtags-auto-update t)     ; buffer保存后，自动更新tags
    (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
    (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
    (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
    (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
    (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
    (define-key helm-gtags-mode-map (kbd "C-c j") 'helm-gtags-tags-in-this-function) ;显示当前函数内部的tag
    (define-key helm-gtags-mode-map (kbd "C-c h") 'helm-gtags-select) ;显示所有的tag
    (define-key helm-gtags-mode-map (kbd "C-c i") 'helm-semantic-or-imenu)
    (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
    (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
    (define-key helm-gtags-mode-map (kbd "C-c f") 'helm-gtags-parse-file) ; 当前文件的所有tag
    (define-key helm-gtags-mode-map (kbd "C-c r") 'helm-gtags-resume) ;针对某个查找过的符号给摘要
    )
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'dired-mode-hook 'helm-gtags-mode)
)


(use-package rustic
  :ensure
  :config
  ;; 存盘时自动格式化。C-c C-c C-o 手动格式化一个buffer
  ;; (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)
  )

;; (defun rk/rustic-mode-hook ()
;;   ;; so that run C-c C-c C-r works without having to confirm, but don't try to
;;   ;; save rust buffers that are not file visiting. Once
;;   ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
;;   ;; no longer be necessary.
;;   (when buffer-file-name
;;     (setq-local buffer-save-without-query t))
;;   (add-hook 'before-save-hook 'lsp-format-buffer nil t))


(use-package toml-mode
  :ensure
  :config
  (add-hook 'toml-mode-hook #'company-mode)
  )


(use-package helm-lsp :ensure)

;; for rust-analyzer integration
;; 各种特性说明 https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.5)
  (gc-cons-threshold (* 100 1024 1024))
  (read-process-output-max (* 1024 1024))
  (treemacs-space-between-root-nodes nil)
  (company-idle-delay 0.0)
  (company-minimum-prefix-length 1)
  ;; This controls the overlays that display type and other hints inline. Enable
  ;; / disable as you prefer. Well require a `lsp-workspace-restart' to have an
  ;; effect on open projects.
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)

  :bind (:map lsp-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-r" . lsp-find-references)
              ("C-c C-c d" . lsp-describe-thing-at-point)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c s" . lsp-rust-analyzer-status)
              ("C-c C-c e" . lsp-rust-analyzer-expand-macro)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c h" . lsp-ui-doc-glance)
              ("C-c C-c D" . dap-hydra)
              )

  :config
  (setq lsp-lens-enable nil)
  ;; minibuf提示的文档说明
  (setq lsp-eldoc-hook nil)
  ;; 光标所在位置关键字高亮
  (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)
  ;; 在变量函数后面标记类型说明，容易被误以为实际写的代码
  (setq lsp-rust-analyzer-server-display-inlay-hints nil)
  ;; 在编辑器抬头显示文件路径和函数名
  (setq lsp-headerline-breadcrumb-enable nil)
  ;; modeline上的灯泡
  (setq lsp-modeline-code-actions-enable t)
  ;; (setq lsp-enable-indentation nil)     ; 关闭lsp的indent
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-hook 'c-mode-hook 'lsp)
  (add-hook 'rustic-mode-hook 'lsp)
  )

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-sideline-enable nil)
  (lsp-ui-peek-always-show nil)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-doc-enable nil))


;; ;; setting up debugging support with dap-mode
;; (use-package exec-path-from-shell
;;   :ensure
;;   :init (exec-path-from-shell-initialize))

;; (when (executable-find "lldb-mi")
;;   (use-package dap-mode
;;     :ensure
;;     :config
;;     (dap-ui-mode)
;;     (dap-ui-controls-mode 1)

;;     (require 'dap-lldb)
;;     (require 'dap-gdb-lldb)
;;     ;; installs .extension/vscode
;;     (dap-gdb-lldb-setup)
;;     (dap-register-debug-template
;;      "Rust::LLDB Run Configuration"
;;      (list :type "lldb"
;;            :request "launch"
;;            :name "LLDB::Run"
;; 	       :gdbpath "rust-lldb"
;;            ;; uncomment if lldb-mi is not in PATH
;;            ;; :lldbmipath "path/to/lldb-mi"
;;            ))))


(server-start)
