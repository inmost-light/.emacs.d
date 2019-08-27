(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq gc-cons-threshold 50000000)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)

(use-package cider
  :ensure t
  :defer t)

;; https://github.com/emacs-dashboard/emacs-dashboard/issues/57#issuecomment-475059483
(use-package dashboard
  :ensure t
  :if (< (length command-line-args) 2)
  :preface
  (defun my/dashboard-banner ()
    "Sets a dashboard banner including information on package initialization
     time and garbage collections."
    (setq dashboard-banner-logo-title
          (format "Emacs ready in %.2f seconds with %d garbage collections."
                  (float-time
                   (time-subtract after-init-time before-init-time)) gcs-done)))
  :init
  (add-hook 'after-init-hook 'dashboard-refresh-buffer)
  (add-hook 'dashboard-mode-hook 'my/dashboard-banner)
  :custom (dashboard-startup-banner 'logo)
  :config (dashboard-setup-startup-hook))

(use-package lisp-mode
  :bind ("C-c C-e" . eval-print-last-sexp))

(use-package magit
  :ensure t
  :defer t)

(use-package paredit
  :ensure t
  :hook ((clojure-mode cider-repl-mode emacs-lisp-mode) . paredit-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook ((clojure-mode cider-repl-mode emacs-lisp-mode) . rainbow-delimiters-mode))

;; https://github.com/nashamri/spacemacs-theme/issues/42#issuecomment-236437989
(use-package spacemacs-common
  :ensure spacemacs-theme
  :config (load-theme 'spacemacs-dark t))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(global-display-line-numbers-mode t)
(show-paren-mode t)
(tool-bar-mode -1)
(blink-cursor-mode -1)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; https://stackoverflow.com/questions/3631220/fix-to-get-smooth-scrolling-in-emacs
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; https://www.emacswiki.org/emacs/BackupDirectory#toc2
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

