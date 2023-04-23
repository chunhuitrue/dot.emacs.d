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
  (delight 'ivy-mode nil "ivy")  
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


;; "C-c SPC" ==> ace-jump-word-mode
;; enter first character of a word, select the highlighted key to move to it.
;; "C-u C-c SPC" ==> ace-jump-char-mode
;; enter a character for query, select the highlighted key to move to it.
;; "C-u C-u C-c SPC" ==> ace-jump-line-mode
;; each non-empty line will be marked, select the highlighted key to move to it.
(use-package ace-jump-mode
  :ensure t
  :config
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
  )


;; If your default face is a fixed pitch (monospace) face, but in AsciiDoc files you liked to have normal text with a variable pitch face, buffer-face-mode is for you: (add-hook 'adoc-mode-hook (lambda() (buffer-face-mode t)))
(use-package adoc-mode
  :ensure t
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
  (define-key global-map (kbd "C-x C-b") 'helm-mini)
  (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
  (define-key global-map (kbd "C-c i") 'helm-semantic-or-imenu)  ; 当前buff中的符号
  (define-key global-map (kbd "C-c o") 'helm-occur)              ; 当前buff中查找关键字
  
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


(use-package helm-rg
  :ensure
  :config
  (setq helm-rg-candidate-limit 2000)
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
              
              ("C-c C-c p" . lsp-describe-thing-at-point)
              ("C-c C-c u" . lsp-ui-doc-glance)
              ("C-c C-c s" . lsp-rust-analyzer-status)
              ("C-c C-c e" . lsp-rust-analyzer-expand-macro)

              ;; ("C-c C-c a" . lsp-execute-code-action)
              ;; ("C-c C-c q" . lsp-workspace-restart)
              ;; ("C-c C-c Q" . lsp-workspace-shutdown)
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


(use-package lsp-treemacs :ensure)


;; 如果系统中没有安装clangd，就不用lsp-mode来索引和扩展。否则会导致索引跳转的快捷键不可用.
;; 另外一个办法就是在项目目录下放入.dir-locals.el。但是需要手动打开一次.dir-locals.el。来触发执行。
(if (executable-find "clangd")
    (add-hook 'c-mode-hook 'lsp)
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  )

;; ;; 同时用两种模式
;; (add-hook 'c-mode-hook 'lsp)
;; (add-hook 'c-mode-hook 'helm-gtags-mode)


;; dap-mode
(use-package exec-path-from-shell
  :ensure
  :init (exec-path-from-shell-initialize))

(when (executable-find "lldb-mi")
  (use-package dap-mode
    :ensure
    :bind (:map dap-mode
                ("C-c C-c h" . dap-hydra)
                )
    :config
    (dap-ui-mode)
    (dap-ui-controls-mode 1)

    (require 'dap-lldb)
    (require 'dap-gdb-lldb)
    ;; installs .extension/vscode
    (dap-gdb-lldb-setup)
    (dap-register-debug-template
     "Rust::LLDB Run Configuration"
     (list :type "lldb"
           :request "launch"
           :name "LLDB::Run"
	       :gdbpath "rust-lldb"
           ;; uncomment if lldb-mi is not in PATH
           ;; :lldbmipath "path/to/lldb-mi"
           ))))


;; https://emacs-lsp.github.io/lsp-mode/page/lsp-lua-lsp/
;; lsp-clients-lua-lsp-server-install-dir 可配 默认是~/.luarocks/bin/
(use-package lua-mode
  :ensure
  :config
  (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
  (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))  
  )


;; ssh中emacs copy的内容放到系统剪切板
;; mac下不需要tmux配合其他配置
;; https://github.com/spudlyo/clipetty
(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode)
  )


(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-hook 'yaml-mode-hook
            #'(lambda ()
                (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  )


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
;;   :ensure t
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
;;   :ensure t
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
