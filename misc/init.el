(menu-bar-mode -1)

(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

(eval-when-compile (require 'use-package))

(use-package doom-modeline
  :ensure t
  :config (doom-modeline-mode 1))

(use-package evil
  :ensure t
  :init
    (setq evil-shift-width 2)
    (setq evil-vsplit-window-right t)
    (setq evil-want-keybinding nil)
  :config (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :custom
    (evil-collection-company-use-tng nil)
    (evil-collection-calendar-want-org-bindings t)
    (evil-collection-setup-minibuffer t)
  :config (evil-collection-init))

(use-package gruvbox-theme :config (load-theme 'gruvbox-light-hard t))

(use-package org :ensure t)

(use-package page-break-lines :ensure t)

(use-package which-key :config (which-key-mode))

(setq column-number-mode t)

(global-page-break-lines-mode)
