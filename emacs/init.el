(require 'use-package)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap 'use-package'
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

(use-package ivy
  :diminish
  :config (ivy-mode))

(use-package swiper
  :bind ("C-S-s" . 'swiper-isearch)
	("C-S-r" . 'swiper-backward))

(use-package diminish)

(use-package powerline
  :config
  (powerline-default-theme)
  (setq powerline-default-separator 'bar))

(use-package solaire-mode
  :config
  (setq solaire-mode-themes-to-face-swap 'doom-one))

(use-package rainbow-mode
  :diminish
  :config (rainbow-mode))

(use-package treemacs
  :hook (treemacs-mode . solaire-mode)
  :config
  (setq treemacs-is-never-other-window t)
  (setq treemacs-width 25))

(use-package company
  :config
  (setq company-minimum-prefix-length 1
      company-idle-delay 0.0)
  (setq lsp-completion-provider :capf))

(use-package lsp-mode
  :config (setq lsp-lens-enable nil)
  :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)

(use-package ccls
;  :mode "\\.cpp\\'"
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
	(lambda () (require 'ccls) (lsp) (company-mode) (electric-pair-mode))))
;  :config
;  (setq ccls-executable "/home/edwin/src/ccls/Release/ccls"))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package typescript-mode)

(defun setup-typescript-hook () (lsp) (company-mode) (electric-pair-mode))
	     
(add-hook 'typescript-mode-hook 'setup-typescript-hook)

(use-package rust-mode
  :config
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(setq rust-format-on-save t)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'rust-mode-hook #'company-mode))

(use-package rustic)

(use-package clojure-mode)

(use-package cider)

(use-package web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;(use-package tide
;  :ensure t
;  :after (typescript-mode js-mode company flycheck)
;  :hook ((typescript-mode . tide-setup)
;         (typescript-mode . tide-hl-identifier-mode)
;;	 (js-mode . tide-setup)
;;         (js-mode . tide-hl-identifier-mode)
;         (before-save . tide-format-before-save)))
;

(use-package vterm
  :config
  (setq vterm-max-scrollback 10000))

(use-package ace-window
  :config
  (global-set-key (kbd "C-x o") 'ace-window))

(use-package magit)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 180))

;(load-theme 'dracula t)
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

(add-to-list 'default-frame-alist '(font . "Source Code Pro-10"))
;(add-to-list 'default-frame-alist '(font . "JetbrainsMono Medium-10"))

(set-frame-size (selected-frame) 150 50)

(global-display-line-numbers-mode)

(dolist (mode '(
		vterm-mode-hook
		sr-speedbar-mode-hook
		info-mode-hook
		help-mode-hook
		compilation-mode-hook
		org-mode-hook
		text-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq display-buffer-alist '(
			     ("\\*Help\\*" (display-buffer-below-selected) (window-height . 0.3))
			     ("\\*Flymake Diagnostics *." (display-buffer-below-selected) (window-height . 0.25))))

(setq edde/prefix-map (make-sparse-keymap))

(setq edde/prefix-key "\C-Z")
(unbind-key (kbd "C-Z"))

(define-minor-mode edde/prefix-mode
  "Minor mode for custom prefix keybindings"
  :lighter ""
  :global t
  :keymap edde/prefix-map)

(edde/prefix-mode 1)

(defmacro edde/prefix-defkey (key name function)
  (list
   'progn
   (list 'defun name '()
	 '(interactive) function)
   (list 'define-key 'edde/prefix-map
	 (list 'concat 'edde/prefix-key key)
	 (list 'quote name))))

(unbind-key (kbd "M-0"))
(unbind-key (kbd "M-1"))
(unbind-key (kbd "M-2"))
(unbind-key (kbd "M-3"))
(unbind-key (kbd "M-4"))
(unbind-key (kbd "M-5"))
(unbind-key (kbd "M-6"))
(unbind-key (kbd "M-7"))
(unbind-key (kbd "M-8"))
(unbind-key (kbd "M-9"))

(bind-key (kbd "C-M-2") "@")
(bind-key (kbd "C-M-3") "£")
(bind-key (kbd "C-M-4") "$")
(bind-key (kbd "C-M-7") "{")
(bind-key (kbd "C-M-8") "[")
(bind-key (kbd "C-M-9") "]")
(bind-key (kbd "C-M-0") "}")

(edde/prefix-defkey "e" edde/expand-region
		    (er/expand-region 1))

(edde/prefix-defkey "c" edde/config
		    (find-file "~/.config/emacs/emacs.org"))

(defun insert-quotes (&optional arg)
  "Insert in quotes"
  (interactive "*P")
  (insert-pair arg ?\" ?\"))

(bind-key "M-\"" #'insert-quotes)

;(global-set-key (kbd "C-x c") '(comment-or-uncomment-region))

(global-set-key (kbd "C-z n") 'tab-next)
(global-set-key (kbd "C-z p") 'tab-previous)
(global-set-key (kbd "C-z t") 'tab-new)

(defun delay-exit ()
  (interactive)
  (save-some-buffers)
;  (sit-for .6)
  (if (boundp 'server-process) (delete-frame) (kill-emacs)))

(bind-key (kbd "C-x C-c") 'delay-exit)

(defun edde/treemacs-then-other ()
  (treemacs) (other-window 1))

(edde/prefix-defkey "s" edde/treemacs
		    (edde/treemacs-then-other))

;(defun (interactive) (rainbow-mode 1))
;(define-globalized-minor-mode rainbow-mode-global rainbow-mode turn-on-rainbow-mode)
;
;(rainbow-mode-global 1)

(add-hook 'eldoc-mode-hook 'company-mode)

(setq disabled-command-function nil)

;; (setq ispell-program-name "~/bin/homebrew/bin/ispell")

(setq parens-require-spaces nil)

(setq ns-right-alternate-modifier nil)

(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg) (set-face-foreground 'mode-line fg))
                               orig-fg))))

(add-to-list 'load-path "~/.emacs.d/packages/")

;(require 'olivetti)

(require 'compile)
(add-hook 'c++-mode-hook
	  (lambda ()
	    (if (not (or (file-exists-p "makefile")
			 (file-exists-p "Makefile")))
		(setq-local compile-command
			    (concat "g++ -o " (file-name-sans-extension buffer-file-name) ".out *.cpp")))))

(setq org-adapt-indentation nil)
(setq org-src-preserve-indentation t)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(defun edde/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.config/emacs/emacs.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'edde/org-babel-tangle-config)))
