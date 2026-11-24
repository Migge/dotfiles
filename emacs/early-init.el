;;; early-init.el --- Settings applied before startup -*- lexical-binding: t; -*-

;;; Commentary:
;; Emacs 27 and later load this file before the package system and before the
;; first frame is created.  Frame parameters set here apply to the initial
;; frame from the start, avoiding a visible redraw, and to every later frame,
;; including those created by emacsclient.

;;; Code:

;;;; Performance

;; Collect garbage less often, during startup and while running language
;; servers.
(setq gc-cons-threshold (* 100 1024 1024))

;;;; Frame appearance

;; Request a frame without window-manager decorations.
(add-to-list 'default-frame-alist '(undecorated . t))

;; Make the frame background, but not its text, partly transparent.
;; `alpha-background' requires Emacs 29 or later.
(when (>= emacs-major-version 29)
  (add-to-list 'default-frame-alist '(alpha-background . 85)))

(provide 'early-init)

;;; early-init.el ends here
