(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(add-to-list 'load-path "~/.emacs.d/site-lisp")


;; package
(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; ;; 163镜像
;; (setq package-archives '(("gnu"    . "http://mirrors.163.com/elpa/gnu/")
;;                          ("nongnu" . "http://mirrors.163.com/elpa/nongnu/")
;;                          ("melpa"  . "http://mirrors.163.com/elpa/melpa/")))

;; ;; 清华镜像
;; (setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;                          ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
;;                          ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; ;; 上海交大镜像
;; (setq package-archives '(("gnu" . "http://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/gnu/")
;;                          ("melpa" . "http://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/melpa/")))

;; ;; emacs-china镜像
;; (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
;;                          ("melpa" . "http://elpa.emacs-china.org/melpa/")))


(server-start)
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
(electric-pair-mode t)
;; (setq word-wrap-by-category t)             ;按照中文折行
(which-key-mode)


;; 全局的默认缩进
(setq tab-width 4)
(setq default-tab-width 4)


(which-function-mode t)
(setq which-func-idle-delay 0.1)
;; ;; 让函数命显示在buffer行首。see：lsp-headerline-breadcrumb-enable
;; (setq-default header-line-format
;;               '((which-func-mode ("" which-func-format " "))))
;; (setq mode-line-misc-info
;;             ;; We remove Which Function Mode from the mode line, because it's mostly
;;             ;; invisible here anyway.
;;       (assq-delete-all 'which-func-mode mode-line-misc-info))

;; mode-line上函数名的颜色
;; 和mode-line上其他文字默认的设置一致。which-function-mode会设置成蓝色
(set-face-attribute 'which-func nil  
                    :foreground "#2e3436")
;; 继承默认。
;; (set-face-attribute 'which-func nil
;;                     :foreground nil)  



;; 平滑地进行半屏滚动，避免滚动后recenter操作
(setq scroll-step 1
      scroll-conservatively 10000)


;; 自动保存
;; (setq auto-save-default nil)
;; (setq undo-tree-auto-save-history nil)

;; ;; (add-to-list 'load-path "~/.emacs.d/site-lisp/auto-save-master")
;; (require 'auto-save)
;; (auto-save-enable)
;; (setq auto-save-silent t)   ; quietly save
;; ;; (setq auto-save-delete-trailing-whitespace t)  ; automatically delete spaces at the end of the line when saving
;; ;; ;;; custom predicates if you don't want auto save.
;; ;; ;;; disable auto save mode when current filetype is an gpg file.
;; ;;   (setq auto-save-disable-predicates
;; ;; 	'((lambda ()
;; ;; 	    (string-suffix-p
;; ;; 	     "gpg"
;; ;; 	     (file-name-extension (buffer-name)) t))))


;; 自动备份
(setq make-backup-files nil)
;; (setq backup-directory-alist '(("." . "~/.emacs_backups"))) ; emacs自动备份文件存入特定目录


(define-key global-map (kbd "M-o") 'other-window)
(define-key global-map (kbd "C-x o") 'ace-window)	; C-x o后?可以调出其他操作的菜单
(define-key global-map (kbd "M-p") 'backward-paragraph) ; 跳到段落空行
(define-key global-map (kbd "M-n") 'forward-paragraph)
(define-key global-map (kbd "M-g M-g") 'avy-goto-char-timer)
(define-key global-map (kbd "M-g l") 'avy-goto-line)
(define-key global-map (kbd "M-g c") 'avy-goto-word-1)
(define-key global-map (kbd "C-x C-a") 'align)
(define-key global-map (kbd "<f8>") 'ibuffer-bs-show)


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
  (delight 'ivy-mode nil "ivy")
  )


;; mode-line
;; (defun dotemacs-buffer-encoding-abbrev ()
;;   "The line ending convention used in the buffer."
;;   (let ((buf-coding (format "%s" buffer-file-coding-system)))
;;     (if (string-match "\\(dos\\|unix\\|mac\\)" buf-coding)
;;         (match-string 1 buf-coding)
;;       buf-coding)))
(setq auto-revert-mode-text "")		; 不显示auto-revert-mode模式标记: ARev
(setq-default mode-line-position
              '("%p (%l,%c)"))
(setq-default mode-line-format
              (list
               "%e"			; 当emacs资源不足的时候，会提示信息
	       mode-line-front-space
	       mode-line-mule-info
	       mode-line-client
	       mode-line-modified
	       mode-line-remote
	       ;; mode-line-frame-identification  ; 不显示frame信息 -UUU:**-  F1  init.el 中的 F1
	       "  "
	       mode-line-buffer-identification
	       "  "
	       mode-line-position
	       "  "
	       mode-line-misc-info
	       mode-line-modes
	       '(:eval `(vc-mode vc-mode))
               ;; "  "
               ;; '(:eval (dotemacs-buffer-encoding-abbrev)) ; 默认已经在文件名前面有显示：-UUU(DOS)@---  新建文本文档.txt
               "  "
	       mode-line-end-spaces
               ))
;; mode-line颜色和tmux状态栏一致
(set-face-attribute 'mode-line nil
                    ;; :foreground "black" 
                    :background "SeaGreen"
                    ;; :background "DarkOliveGreen"
                    ;; :background "#32CD32" ; 不太亮的绿色
                    ;; :background "LimeGreen" ; 不太亮的绿色
                    ;; :background "#5F8787" ; 暗青色
                    ;; :background "CadetBlue" ;  暗青色
                    )
;; (set-face-attribute 'mode-line-inactive nil
;;                     :foreground "black"
;;                     :background "light gray"
;;                     )


(use-package golden-ratio
  :ensure
  :delight golden-ratio-mode
  :init
  (golden-ratio-mode)
  :config
  ;; ace-window用编号切换窗口后，激活光标所在窗口的golden-ratio
  ;; 使其按比例放大
  (defun my-ace-window-advice (&rest _)
    "My custom advice for `ace-window'."
    (golden-ratio)
     )
  (advice-add 'ace-window :after #'my-ace-window-advice)

  ;; 在ediff 和helm界面下禁用
  ;; https://github.com/roman/golden-ratio.el/wiki
  ;; ediff
  (eval-after-load "golden-ratio"
    '(progn
       (add-to-list 'golden-ratio-exclude-modes "ediff-mode")
       (add-to-list 'golden-ratio-inhibit-functions 'pl/ediff-comparison-buffer-p)))

  (defun pl/ediff-comparison-buffer-p ()
    (and (boundp 'ediff-this-buffer-ediff-sessions)
	 ediff-this-buffer-ediff-sessions))

  (add-hook 'ediff-startup-hook 'my-ediff-startup-hook)

  (defun my-ediff-startup-hook ()
    "Workaround to balance the ediff windows when golden-ratio is enabled."
    (ediff-toggle-split)
    (ediff-toggle-split))
  )


(use-package yasnippet
  :ensure
  :delight yas-minor-mode
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode)
  )

(use-package   yasnippet-snippets
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
              ("M->". company-select-last)
	      )
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
  :delight flycheck-mode  ; 不在mode-line上显示警告数量，lsp已经显示了
  )


(use-package magit
  :ensure
  :config
  ;; 此设置可使 “Recent commits” 和 “Unpulled from upstream” 在打开 magit-st时自动展开。
  ;; (setq magit-section-initial-visibility-alist
  ;;       '(
  ;;         ;; (stashes . hide)
  ;;         ;; (untracked . show)
  ;;         ;; (unstaged . show)
  ;;         ;; (unpushed . show)
  ;;         (unpulled . show)    ; 需要手动按 f a 显示unpulled，然后才默认显示
  ;;         ))

  ;; transient弹出窗口的key颜色
  (custom-set-faces
   '(transient-key-exit ((((type tty)) (:foreground "#d1478e")))) ; 默认的粉色看不清
   '(transient-key-stay ((((type tty)) (:foreground "green"))))
   )
  )


(use-package helm
  :ensure
  :config
  (define-key global-map (kbd "C-x C-b") 'helm-mini)
  (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
  (define-key global-map (kbd "C-c i") 'helm-semantic-or-imenu)  ; 当前buff中的符号
  (define-key global-map (kbd "C-c o") 'helm-occur)              ; 当前buff中查找关键字

  ;; helm的窗口显示。
  ;; 固定用 bottom 窗口
  ;; (add-to-list 'display-buffer-alist
  ;;              '("^\\*helm .*"
  ;;                (display-buffer-at-bottom)))
  ;; 固定用 side 窗口
  (add-to-list 'display-buffer-alist
               '("^\\*helm .*"
                 (display-buffer-in-side-window)
                 (side . bottom)))
  )


;; https://github.com/bbatsov/helm-projectile
;; https://tuhdo.github.io/helm-projectile.html
(use-package helm-projectile
  :ensure
  :init
  ;; (helm-projectile-on)
  )


;; https://docs.projectile.mx/projectile/configuration.html
(use-package projectile
  :ensure
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


(use-package yaml-mode
  :ensure
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-hook 'yaml-mode-hook
            #'(lambda ()
                (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  )


;; If your default face is a fixed pitch (monospace) face, but in AsciiDoc files you liked to have normal text with a variable pitch face, buffer-face-mode is for you: (add-hook 'adoc-mode-hook (lambda() (buffer-face-mode t)))
;; (use-package adoc-mode)


(use-package json-mode
  :ensure
  :config
  (add-hook 'json-mode-hook #'flycheck-mode)
  (add-hook 'json-mode-hook #'company-mode)
  )


;; ;; https://emacs-lsp.github.io/lsp-mode/page/lsp-lua-lsp/
;; ;; lsp-clients-lua-lsp-server-install-dir 可配 默认是~/.luarocks/bin/
;; (use-package lua-mode
;;   :ensure
;;   :config
;;   (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
;;   (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
;;   (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
;;   )


(use-package cc-mode
  :ensure
  :config
  (add-hook 'c-mode-common-hook		; 缩进
            (lambda ()
              (setq indent-tabs-mode nil)
              (setq c-basic-offset 4)
              (setq c-default-style "linux")
              ))

  ;; 如果系统中没有安装clangd，或者虽然安装了clangd，但是项目无法编译。
  ;; 就不用lsp-mode来索引和扩展。否则会导致索引跳转的快捷键不可用.
  ;; 另外一个办法是在项目目录下放入.dir-locals.el
  (if (executable-find "clangd")
      (add-hook 'c-mode-hook 'lsp)
    (add-hook 'c-mode-hook 'helm-gtags-mode)
    )
  ;; ;; 同时用两种模式
  ;; (add-hook 'c-mode-hook 'lsp)
  ;; (add-hook 'c-mode-hook 'helm-gtags-mode)
  )


;; #if 0 区域变灰
(use-package hideif
  :ensure
  :init
  (progn
    (setq hide-ifdef-style 'font-lock)
    (setq hide-ifdef-global-modes '(c-mode c++-mode))
    (add-hook 'c-mode-common-hook
              (lambda ()
		(setq hide-ifdef-shadow t)
		(setq hide-ifdef-mode t)
		(hide-ifdefs)))
    ))


(use-package rustic
  :ensure
  :config
  (add-hook 'rustic-mode-hook 'lsp)

  (add-hook 'rustic-mode-hook 		; 缩进固定用4个空格
            (lambda ()
              (setq indent-tabs-mode nil)
              (setq rust-indent-offset 4)
	      ))

  ;; ;; 编译buffer字体颜色
  ;; (custom-set-faces
  ;;  ;; '(rustic-compilation-column ((t (:inherit compilation-column-number))))
  ;;  ;; '(rustic-compilation-line ((t (:foreground "LimeGreen"))))
  ;;  ;; '(rustic-message ((t (:foreground "LimeGreen"))))
  ;;  ;; '(rustic-compilation-error ((t (:foreground "red"))))
  ;;  ;; '(rustic-compilation-warning ((t (:foreground "LimeGreen"))))
  ;;  ;; '(rustic-compilation-info ((t (:foreground "LimeGreen"))))
  ;;  )

  ;; 重新定义C-c C-c k  clippy 和 C-c C-c C-u build。编译结果buffer的颜色，否则提示特定行的蓝色看不清
  ;; 默认：https://github.com/brotzeit/rustic/blob/master/rustic-compile.el#L118
  (setq rustic-ansi-faces ["black"
                           "red2"
                           "green3"
                           "yellow3"
                           "cyan2"
                           "magenta3"
                           "cyan3"
                           "white"])

  ;; 存盘时自动格式化。
  ;; 并且重构代码的时候，不需要提示保存
  ;; 也可以C-c C-c C-o 手动格式化一个buffer
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)
  (defun rk/rustic-mode-hook ()
    ;; so that run C-c C-c C-r works without having to confirm, but don't try to
    ;; save rust buffers that are not file visiting. Once
    ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
    ;; no longer be necessary.
    (when buffer-file-name
      (setq-local buffer-save-without-query t))
    (add-hook 'before-save-hook 'lsp-format-buffer nil t))
  )


(use-package toml-mode
  :ensure
  :config
  (add-hook 'toml-mode-hook #'company-mode)
  )


;; https://github.com/Alexander-Miller/treemacs/issues/100
;; https://github.com/Alexander-Miller/treemacs/issues/742
;; 颜色模式没有默认的背景色...
;; 加上这个配置后，去除daemon启动的时候提示的如下警告，带警告也没其他影响
;; [Treemacs] Warning: coudn’t find default background colour for icons, falling back on #2d2d31.
;; [Treemacs] Warning: couldn’t find hl-line-mode’s background color for icons, falling back on #2d2d31.
(use-package treemacs
  :ensure
  :init
  (setq treemacs-no-load-time-warnings t)
  )


(use-package helm-xref
  :ensure
  :config
  (define-key global-map [remap find-file] #'helm-find-files)
  (define-key global-map [remap execute-extended-command] #'helm-M-x)
  (define-key global-map [remap switch-to-buffer] #'helm-mini)
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
    (define-key helm-gtags-mode-map (kbd "C-c j") 'helm-gtags-tags-in-this-function) ; 当前函数内部的符号
    (define-key helm-gtags-mode-map (kbd "C-c h") 'helm-gtags-select)                ; 整个项目的符号
    (define-key helm-gtags-mode-map (kbd "C-c f") 'helm-gtags-parse-file)            ; 分析当前文件的所有符号
    (define-key helm-gtags-mode-map (kbd "C-c r") 'helm-gtags-resume)                ;针对某个查找过的符号给摘要
    (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
    (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
    )
  (add-hook 'dired-mode-hook 'helm-gtags-mode)
)


;; https://github.com/emacs-lsp/helm-lsp
;; helm-lsp-workspace-symbol - workspace symbols for the current workspace
;; helm-lsp-global-workspace-symbol - workspace symbols from all of the active workspaces.
;; helm-lsp-code-actions - helm interface to lsp-execute-code-action.
;; helm-lsp-switch-project - switch lsp-mode project (when helm-projectile is present)
;; helm-lsp-diagnostics - browse the errors in the project.
;; Sample query: *err #Test.js Foo Bar will return all of the errors which message contains Foo and Bar, it is in file Test.js and its severity is error
(use-package helm-lsp
  :ensure
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)
  )


;; 各种特性说明 https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  (lsp-eldoc-render-all nil) ; 自动在minibuf显示函数的文档打扰太多，关闭。
  (lsp-idle-delay 0.1)
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
              ;; 跳到定义  M-.  xref-find-definitions
              ;; 返回      M-,  xref-pop-marker-stack
              ("M-r" . lsp-find-references)
              ("M-j" . lsp-ui-imenu)                    ; 当前buff内的符号。没有模糊查找 helm-semantic-or-imenu 或 helm-imenu 更好.
              ("C-c C-c S" . lsp-treemacs-symbols)      ; 当前buff内的符号。没模糊查找。
              ("C-c x i" . helm-lsp-workspace-symbol)   ; 整个项目的符号。

              ("C-c C-c g" . lsp-find-definition)      ; 同 M-.
              ("C-c C-c d" . lsp-find-declaration)     ; 同 M-.
              ("C-c C-c t" . lsp-find-type-definition) ; 同 M-.
              ("C-c C-c i" . lsp-find-implementation)
              ("C-c C-c h" . lsp-treemacs-call-hierarchy)  ; 显示函数调用级别

              ("C-c C-p r" . lsp-ui-peek-find-references)
              ("C-c C-p d" . lsp-ui-peek-find-definitions)   ; 同 M-.
              ("C-c C-p i" . lsp-ui-peek-find-implementation)
              ;; ("C-c C-p s" . lsp-ui-peek-find-workspace-symbol) ; 整个项目的符号。c语言中找不到。helm-lsp-workspace-symbol 更好

              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c a" . lsp-execute-code-action) ; 对应lsp-modeline-code-actions-enable mode line上的灯泡。可以执行光标所在代码的动作

              ("C-c C-c p" . lsp-describe-thing-at-point)
              ("C-c C-c u" . lsp-ui-doc-glance)
              ("C-c C-c s" . lsp-rust-analyzer-status)
              ("C-c C-c e" . lsp-rust-analyzer-expand-macro)

              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              )
  :config
  (setq lsp-lens-enable nil)
  (setq lsp-eldoc-hook nil)                                 ; minibuf提示的文档说明，太打扰。用lsp-ui-doc-glance
  (setq lsp-enable-symbol-highlighting nil)                 ; 光标所在位置关键字高亮
  ;; (setq lsp-signature-auto-activate nil)
  (setq lsp-rust-analyzer-server-display-inlay-hints nil)   ; 在变量函数后面标记类型说明，容易被误以为实际写的代码
  (setq lsp-headerline-breadcrumb-enable nil)               ; 在编辑器抬头显示文件路径和函数名。see: which-function-mode
  (setq lsp-modeline-code-actions-enable t)                 ; modeline上的灯泡
  ;; (setq lsp-enable-indentation nil)                      ; 关闭lsp的indent.目录下用.clang_format
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  )


(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-sideline-enable nil)
  (lsp-ui-peek-always-show nil)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-doc-enable nil))


(use-package lsp-treemacs
  :ensure
  )


;; ;; dap-mode 需要此包
;; (use-package exec-path-from-shell
;;   :init (exec-path-from-shell-initialize))

;; ;; dap-mode
;; ;; https://robert.kra.hn/posts/rust-emacs-setup/
;; (when (executable-find "lldb-mi")
;;   (use-package dap-mode
;;     :bind (:map dap-mode
;;                 ("C-c C-c y" . dap-hydra)
;;                 )
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


;; 远程ssh中emacs copy的内容放到系统剪切板
;; mac下不需要tmux配合其他配置
;; https://github.com/spudlyo/clipetty
(use-package clipetty
  :ensure
  :hook (after-init . global-clipetty-mode)
  )

;; 解决问题：macos在本地tmux中的emacs，copy的内容无法放到系统剪切板
;; 需要支持： brew install reattach-to-user-namespace
(when (eq system-type 'darwin) 
  (defun copy-from-osx ()
    "Use OSX clipboard to paste."
    (shell-command-to-string "reattach-to-user-namespace pbpaste"))

  (defun paste-to-osx (text &optional push)
    "Add kill ring entries (TEXT) to OSX clipboard.  PUSH."
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "reattach-to-user-namespace" "pbcopy")))
	(process-send-string proc text)
	(process-send-eof proc))))

  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))


;; window layout布局,tabbar方式:
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Tab-Bars.html
;; 新建一个tab    tab-new C-x t 2
;; 关闭一个tab    tab-close C-x t 0
;; tab改名        tab-rename C-x t r
;; 切换上一次tab  tab-switch C-x t RET
;; 后一个tab      tab-next C-x t o
;; 前一个tab      tab-previous C-x t O
;; 移动tab        tab-move C-x t m
;; tab列表        tab-list 也可以在其中标记D，然后x删除tab
;; 关闭所有标签，除了当前标签 C-x t 1
(setq tab-bar-close-last-tab-choice 'tab-bar-mode-disable)  ; tab-close可以关闭最后一个tab，参考：C-h v 查看这个变量的介绍


;; ;; window layout布局elscreen方式,效果不好
;; ;; 布局1中已经打开了一个buff tt.txt，这是在布局2中切换buff到tt.txt，会跳到布局1,然后就不再跳了
;; ;; https://github.com/knu/elscreen
;; ;; C-z c
;; ;; C-z C-c
;; ;; Create a new screen and switch to it.
;; ;; C-z C
;; ;; Create a new screen with the window-configuration of the current screen.
;; ;; C-z k
;; ;; C-z C-k
;; ;; Kill current screen.
;; ;; C-z M-k
;; ;; Kill current screen and buffers.
;; ;; C-z K
;; ;; Kill other screens.
;; ;; C-z n
;; ;; C-z C-n
;; ;; Switch to the "next" screen in a cyclic order.
;; ;; C-z p
;; ;; C-z C-p
;; ;; Switch to the "previous" screen in a cyclic order.
;; ;; C-z a
;; ;; C-z C-a
;; ;; Toggle to the screen selected previously.
;; ;; C-z '
;; ;; Prompt for a screen number to switch to.
;; ;; C-z "
;; ;; Present a list of all screens for selection.
;; ;; C-z 0..9
;; ;; Jump to the screen number 0-9.
;; ;; C-z C-s
;; ;; Swap current screen with previous one.
;; ;; C-z w
;; ;; C-z C-w
;; ;; Show a list of screen.
;; ;; C-z A
;; ;; Allow the user to enter a name for the current screen.
;; ;; C-z m
;; ;; C-z C-m
;; ;; Repeat the last message displayed in the mini-buffer.
;; ;; C-z t
;; ;; C-z C-t
;; ;; C-z b
;; ;; Switch to the screen in which specified buffer is splayed.
;; ;; C-z C-f
;; ;; Create new screen and open file.
;; ;; C-z C-r
;; ;; Create new screen and open file but don't allow changes.
;; ;; C-z d
;; ;; Create new screen and run dired.
;; ;; C-z M-x
;; ;; Read function name, then call it with new screen.
;; ;; C-z i
;; ;; Show/hide the screen number in the mode line.
;; ;; C-z T
;; ;; Show/hide the tab on the top of each frame.
;; ;; C-z v
;; ;; Display ElScreen version.
;; ;; C-z ?
;; ;; Show key bindings of ElScreen and Add-On softwares.
;; (use-package elscreen
;;   :config
;;   (setq elscreen-prefix-key "\C-z")     ; C-z 默认是挂起emacs到后台,改为elscreen前缀之后，可以用C-x C-z 来挂起emacs
;;   )
;; (elscreen-start)


;; ;; window layout布局,ivy view方式,不是想要的效果
;; ;; ivy-push-view保存当前窗口布局，ivy-pop-view删除窗口布局，ivy-switch-view 切换窗口布局。
;; ;; ivy-switch-buffer C-x b 切换buffer，其中包含保存的布局。
;; ;; 在保存了layout之后，跳转到了其他文件。
;; ;; 这时切换到其他地方再切换回原来名字的layout，会恢复最初的状态，并不会保留最后跳转后的状态。
;; ;; 如果要保留最后状态，需要切换之前保存一下当前layout。  很麻烦
;; (use-package ivy
;;   :delight ivy-mode
;;   :hook (after-init . ivy-mode)
;;   :config
;;   (global-set-key (kbd "C-c v") 'ivy-push-view)
;;   (global-set-key (kbd "C-c V") 'ivy-pop-view)
;;   (setq ivy-use-virtual-buffers t)      ; ivy-switch-buffer可以切换recentf, bookmarks, windows layout
;;   ;; ;; 设置默认的layout
;;   ;; ;; https://oremacs.com/2016/06/27/ivy-push-view/
;;   ;; (setq ivy-views
;;   ;;     `(("dutch + notes {}"
;;   ;;        (vert
;;   ;;         (file "dutch.org")
;;   ;;         (buffer "notes")))
;;   ;;       ("ivy.el {}"
;;   ;;        (horz
;;   ;;         (file ,(find-library-name "ivy"))
;;   ;;         (buffer "*scratch*")))))
;;   )


;; rg需要此包
(use-package   wgrep
  :ensure
  )


;; https://github.com/dajva/rg.el
;; https://rgel.readthedocs.io/en/latest/usage.html#results-buffer
;; rgel-readthedocs-io-en-latest.pdf
;; rg-menu C-c s
;; https://github.com/dajva/rg.el
;; https://rgel.readthedocs.io/en/latest/usage.html#results-buffer
;; rgel-readthedocs-io-en-latest.pdf

;; rg-menu C-c s 调出主菜单
;; 路径文件名选项等，作为交互式选项可选
;; C-c s t (rg-literal)       把搜索内容作为纯文本来搜索
;; C-c s r (rg)               把搜索内容作为正则来搜索
;; C-c s p (rg-project)       在项目内搜索。
;; C-c s d (rg-dwim)          自动根据上下文条件的搜索

;; 结果buffer移动
;; M-n                 Move to next line with a match.
;; M-p                 Move to previous line with a match.
;; n                   Move to next line with a match, show that file in other buffer and highlight the match.
;; p                   Move to previous line with a match, show that file in other buffer and highlight the match.
;; M-N (rg-next-file)  Move to next file header if the results is grouped under a file header (See rg-group-result).
;; M-P (rg-prev-file)  Move to previous file header if the results is grouped under a file header (See rg-group-result).

;; 结果buff中重定义搜索
;; d (rg-rerun-change-dir)     Interactively change search directory.
;; f (rg-rerun-change-files)   Interactively change searched file types.
;; t (rg-rerun-change-literal) Interactively change search string interpret the string literally.
;; r (rg-rerun-change-regexp)  Interactively change search string interpret the string as a regular expression.
;; g (rg-recompile)            Rerun the current search without changing any parameters.
;; c (rg-rerun-toggle-case)    Toggle case sensitivity of search. The state of the flag is shown in the [case] header field.
;; i (rg-rerun-toggle-ignore)  Toggle if ignore files are respected. The state of the flag is shown in the [ign] header field.
;; m (rg-menu)                 Fire up the menu for full access to options and flags.

;; 搜索历史
;; C-c < (rg-back-history)     Navigate back in history.
;; C-c > (rg-forward-history)  Navigate forward in history.

;; 其他
;; 搜索结果中按e可以编辑，C-c C-c应用到文件（没有保存命令，可以用C-x s统一保存所有buffer）C-c C-k取消编辑
;; 还可以保存编辑结果
(use-package rg
  :ensure
  :config
  (rg-enable-default-bindings)
  )


;; ;; 查找项目下的文件. 作为helm-projectile-find-file的备用
;; ;; https://github.com/redguardtoo/find-file-in-project#find-file-in-project-at-point
;; ;; find-file-in-project
;; ;; find-file-in-current-directory
;; (use-package find-file-in-project
;;   :ensure
;;   :config
;;   (helm-mode 1)
;;   (setq ffip-use-rust-fd t)
;;   )


;; 自动删除行尾空格
;; https://github.com/lewang/ws-butler
(use-package ws-butler
  :ensure
  :hook (
	 ;; (text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)
	 )
  :config
  (setq ws-butler-global-exempt-modes '(special-mode))
  (setq ws-butler-keep-whitespace-before-point nil)
  (setq ws-butler-trim-predicate
	(lambda (beg end)
          (not (eq 'font-lock-string-face
                   (get-text-property end 'face)))))
  )


;; 高亮符号
(use-package symbol-overlay
  :ensure
  :config
  (setq symbol-overlay-scope t)
  :bind
  (("M-i" . symbol-overlay-put))
  )


;; ;; 自动高亮光标所在位置的符号
;; (use-package highlight-symbol
;;   :ensure
;;   :hook (prog-mode . highlight-symbol-mode)
;;   :config
;;   (setq highlight-symbol-idle-delay 0.1) ; 可选的，设置延迟时间
;;   ;; (set-face-foreground 'highlight-symbol-face "black") ; 默认前景色
;;   ;; (set-face-background 'highlight-symbol-face "light yellow") ; 默认背景色
;;   )


;; https://github.com/casouri/vundo
(use-package vundo
  :ensure
  :config
  (define-key global-map (kbd "<f7>") 'vundo)
  ;; (setq vundo-glyph-alist vundo-unicode-symbols)
  (set-face-attribute 'vundo-default nil :family "Symbola")
  )


(use-package dogears
  :ensure
  :hook (after-init . dogears-mode)
  :bind (:map global-map
              ("M-g d" . dogears-go)
              ("M-g M-b" . dogears-back)
              ("M-g M-f" . dogears-forward)
              ("M-g M-d" . dogears-list)
              ("M-g M-D" . dogears-sidebar))
  :config
  (setq dogears-idle 1
        dogears-limit 200
        dogears-position-delta 20)
  (setq dogears-functions '(find-file recenter-top-bottom
                                      other-window switch-to-buffer
                                      aw-select toggle-window-split
                                      windmove-do-window-select
                                      pager-page-down pager-page-up
                                      tab-bar-select-tab
                                      pop-to-mark-command
                                      pop-global-mark
                                      goto-last-change
                                      xref-go-back
                                      xref-find-definitions
                                      xref-find-references)))


;; 让tmux窗口名显示为emacsclient的当前buff名
(defun update-tmux-window-name ()
  "更新tmux窗口名称为当前激活的emacs缓冲区名称，如果是一个普通文件缓冲区。并且忽略*开头的来临时buff"
  (interactive)
  (let ((buffer-name (buffer-name)))
    (when (and buffer-name (not (string-match-p "\\*" buffer-name)))
      (shell-command (format "tmux rename-window '%s'" buffer-name)))))

(add-hook 'server-after-make-frame-hook 'update-tmux-window-name)
(add-hook 'buffer-list-update-hook 'update-tmux-window-name)

(defun reset-tmux-window-name ()
  "在emacsclient断开连接时重置tmux窗口名称。"
  (interactive)
  (shell-command "tmux set-window-option automatic-rename on")) ; 你可以根据需要更改重置后的窗口名称

(defun add-tmux-reset-on-exit ()
  "为当前frame添加退出时更新tmux窗口名称的功能。"
  (add-hook 'delete-frame-functions
            (lambda (frame)
              (when (eq frame (selected-frame))
                (reset-tmux-window-name)))))

(add-hook 'server-after-make-frame-hook 'add-tmux-reset-on-exit)

