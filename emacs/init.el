;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration.
;;
;; This file bootstraps package management and installs configured packages
;; automatically when they are missing.  Settings that must apply before the
;; first frame is drawn live in early-init.el.

;;; Code:

;;;; Package management

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;; Emacs 27 and later activate installed packages before loading this file.
(when (< emacs-major-version 27)
  (package-initialize))

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

;; Custom writes its settings (including `package-selected-packages') to this
;; machine-local file instead of appending them to this version-controlled
;; init.el.
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
      display-line-numbers-type 'relative)

(menu-bar-mode -1)
(tool-bar-mode -1)
(global-display-line-numbers-mode 1)

(use-package dracula-theme
  :config
  (load-theme 'dracula t))

;; Show the available keys after typing a prefix such as C-c l.
;; Built into Emacs 30; installed from GNU ELPA on older versions.
(use-package which-key
  :init
  (which-key-mode 1))

;;;; General editing behavior

;; Automatically reload files changed outside Emacs.
(global-auto-revert-mode 1)

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

;; Start LSP only in modes that have a language server configured, rather than
;; in every `prog-mode' buffer (which includes Emacs Lisp).  Run M-x lsp to
;; start it manually elsewhere.
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (((js-ts-mode typescript-ts-mode tsx-ts-mode css-ts-mode
           json-mode kotlin-mode groovy-mode dart-mode)
          . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :custom
  (lsp-clients-typescript-prefer-use-project-ts-server t)
  :init
  (setq lsp-completion-provider :none)
  ;; A bare "C-c" would shadow every major-mode binding under C-c.
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-diagnostics-provider :flycheck))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package flycheck
  :hook (lsp-mode . flycheck-mode)
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error))
  :custom (flycheck-display-errors-delay .3))

;;;; Dart

(use-package dart-mode)

;; Provides additional Dart and Flutter integration for lsp-mode.
(use-package lsp-dart
  :after (dart-mode lsp-mode))

;;;; Org mode

;; `org-tempo' is included with Org, so it must not be installed separately.
(use-package org-tempo
  :ensure nil
  :after org)

;; Change this path on machines where PlantUML is stored elsewhere.
(defvar my/plantuml-jar-path
  (expand-file-name "plantuml.jar" user-emacs-directory)
  "Local PlantUML jar used by both `plantuml-mode' and Org Babel.")

;; Render with the local jar.  The package default, `server', uploads every
;; previewed diagram to plantuml.com.
(use-package plantuml-mode
  :custom
  (plantuml-default-exec-mode 'jar)
  (plantuml-jar-path my/plantuml-jar-path))

(with-eval-after-load 'org
  (require 'ob-plantuml)

  (setq org-plantuml-jar-path my/plantuml-jar-path)

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
;; The garbage-collection threshold is raised in early-init.el.
(setq read-process-output-max (* 1024 1024))

(provide 'init)

;;; init.el ends here
