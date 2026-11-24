;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration.
;;
;; This file bootstraps package management and installs configured packages
;; automatically when they are missing.

;;; Code:

;;;; Package management

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;; Package initialization happens automatically in recent Emacs versions,
;; but calling this explicitly also supports older versions.
(package-initialize)

(defun my/package-refresh-if-needed ()
  "Refresh package metadata when no archive metadata is available."
  (unless package-archive-contents
    (package-refresh-contents)))

;; `use-package' is built into recent Emacs versions. Install it when running
;; a version where it is not already available.
(unless (require 'use-package nil 'noerror)
  (my/package-refresh-if-needed)
  (package-install 'use-package)
  (require 'use-package))

(setq use-package-always-ensure t
      use-package-expand-minimally t)

;;;; Keep generated Custom settings separate

(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

;;;; Emacs server

(require 'server)

(unless (server-running-p)
  (server-start))

;;;; Interface

(setq inhibit-startup-screen t
      delete-by-moving-to-trash t
      display-line-numbers-type 'relative)

(menu-bar-mode -1)
(tool-bar-mode -1)
(global-display-line-numbers-mode 1)

(use-package dracula-theme
  :config
  (load-theme 'dracula t))

;;;; General editing behavior

;; Automatically reload files changed outside Emacs.
(global-auto-revert-mode 1)

;; Warn when part of a file name is hidden by an environment variable.
(file-name-shadow-mode 1)

;; Move deleted files to the operating system's trash.
(setq delete-by-moving-to-trash t)

;; Switch to the next window with Ctrl+Tab.
(global-set-key (kbd "C-<tab>") #'other-window)

;;;; Completion

(use-package vertico
  :init
  (setq vertico-resize nil)
  (vertico-mode 1)
  :hook
  (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package marginalia
  :init
  (marginalia-mode 1))

;;;; Dired

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;;;; Programming modes

(use-package groovy-mode)

(use-package yaml-mode)

(use-package json-mode
  :hook
  (json-mode . my/json-mode-setup))

(defun my/json-mode-setup ()
  "Use two-space indentation in JSON buffers."
  (setq-local tab-width 2)
  (setq-local js-indent-level 2))

(use-package kotlin-mode)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(javascript typescript tsx css html))
  (treesit-auto-add-to-auto-mode-alist '(javascript typescript tsx css html))
  (global-treesit-auto-mode))


;;;; LSP

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((prog-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :custom
  (read-process-output-max (* 1024 1024))
  :custom
  (lsp-clients-typescript-prefer-use-project-ts-server t)
  :init
  (setq lsp-completion-provider :none)
  (setq lsp-keymap-prefix "C-c")
  (setq lsp-diagnostics-provider :flycheck))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package flycheck
  :hook (lsp-mode . flycheck-mode)
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-previous-error)
              ("M-p" . flycheck-next-error))
  :custom (flycheck-display-errors-delay .3))


;; (use-package lsp-mode
;;   :commands (lsp lsp-deferred)
;;   :custom
;;   ;; Increase the amount of data Emacs can read from language servers.
;;   (read-process-output-max (* 1024 1024)))

;;;; Dart

(use-package dart-mode
  :hook
  (dart-mode . lsp-deferred))

;; Provides additional Dart and Flutter integration for lsp-mode.
(use-package lsp-dart
  :after (dart-mode lsp-mode))

;;;; Org mode

;; `org-tempo' is included with Org, so it must not be installed separately.
(use-package org-tempo
  :ensure nil
  :after org)

(use-package plantuml-mode)

(with-eval-after-load 'org
  (require 'ob-plantuml)

  ;; Change this path on machines where PlantUML is stored elsewhere.
  (setq org-plantuml-jar-path
        (expand-file-name "~/.emacs.d/plantuml.jar"))

  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)))

  (add-hook 'org-babel-after-execute-hook
            #'org-redisplay-inline-images))

(defun my/org-confirm-babel-evaluate (language _body)
  "Ask before evaluating Babel code, except for PlantUML LANGUAGE blocks."
  (not (string-equal language "plantuml")))

(setq org-confirm-babel-evaluate
      #'my/org-confirm-babel-evaluate)

;;;; Performance

;; Give language servers and other subprocesses a larger communication buffer.
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024))

;;;; Frame appearance

(defun my/configure-frame (frame)
  "Apply personal appearance settings to FRAME."
  (with-selected-frame frame
    (when (display-graphic-p)
      (set-frame-parameter frame 'undecorated t)

      ;; `alpha-background' is supported by newer Emacs versions.
      (when (>= emacs-major-version 29)
        (set-frame-parameter frame 'alpha-background 85)))))

;; Apply settings to the initial frame.
(my/configure-frame (selected-frame))

;; Apply settings to frames created by emacsclient or later commands.
(add-hook 'after-make-frame-functions #'my/configure-frame)

(add-to-list 'default-frame-alist '(undecorated . t))

(when (>= emacs-major-version 29)
  (add-to-list 'default-frame-alist '(alpha-background . 85)))

(provide 'init)


;;; init.el ends here

