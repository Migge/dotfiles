(require 'server)
(unless (server-running-p)
  (server-start))

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(use-package dracula-theme)
(use-package groovy-mode)
(use-package yaml-mode)
(use-package vertico)
(use-package marginalia)
(use-package plantuml-mode)
(use-package json-mode)
(use-package kotlin-mode)
(use-package dart-mode)
(use-package org-tempo
  :demand t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff"
    "#eeeeec"])
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("0223215a464167d93b9cfef9b1cdf9b0768ab660f33b3068b647f7b12aa453a0"
     "8721f7ee8cd0c2e56d23f757b44c39c249a58c60d33194fe546659dabc69eebd"
     "7b8f5bbdc7c316ee62f271acf6bcd0e0b8a272fdffe908f8c920b0ba34871d98"
     default))
 '(display-line-numbers 'relative)
 '(display-line-numbers-mode t t)
 '(inhibit-startup-screen t)
 '(ispell-dictionary nil)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(company dart-mode dracula-theme flycheck groovy-mode helm-lsp hover
	     hydra json-mode kotlin-mode lsp-dart lsp-java lsp-mode
	     lsp-treemacs-flycheck lsp-ui marginalia marginalia-mode
	     plantuml-mode projectile unfill use-package vertico
	     vertico-mode yaml-mode yasnippet))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'dracula t)

;; Auto-refresh changed files
(global-auto-revert-mode t)

;; Add Ctrl-Tab support for switching multiple windows
(global-set-key (kbd "C-<tab>") 'other-window)

(file-name-shadow-mode 1)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

(setq vertico-resize nil)
(vertico-mode 1)

(marginalia-mode 1)

(setq delete-by-moving-to-trash t)

(add-hook 'dired-mode-hook 'dired-hide-details-mode)

;; Plantuml
(require 'ob-plantuml)

(setq org-plantuml-jar-path (expand-file-name "~/Dropbox/linux/plantuml.jar"))
(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
;; (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t))))
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
(defun my-org-confirm-babel-evaluate (lang body)
  (not (string= lang "plantuml")))  ; don't ask for plantuml
(setq org-confirm-babel-evaluate #'my-org-confirm-babel-evaluate)


;; JSON
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq tab-width 2)
            (setq js-indent-level 2)))


;; Dart
(add-hook 'dart-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024))
;; (set-frame-parameter (selected-frame) 'alpha '(90 90))
;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter nil 'alpha-background 85) ; 0-100, where 100 is opaque
(add-to-list 'default-frame-alist '(alpha-background . 85))

(add-to-list 'default-frame-alist '(undecorated . t))
;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (with-selected-frame frame
;;               (set-frame-parameter frame 'undecorated t)
;;               (toggle-frame-maximized))))
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (set-frame-parameter frame 'undecorated t)))
(set-frame-parameter nil 'undecorated t)

