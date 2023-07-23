(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("8721f7ee8cd0c2e56d23f757b44c39c249a58c60d33194fe546659dabc69eebd" "7b8f5bbdc7c316ee62f271acf6bcd0e0b8a272fdffe908f8c920b0ba34871d98" default))
 '(display-line-numbers 'relative)
 '(display-line-numbers-mode t t)
 '(inhibit-startup-screen t)
 '(ispell-dictionary nil)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(dracula-theme gruvbox-theme nordic-night-theme nord-theme))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-frame-parameter (selected-frame) 'alpha '(85 85))
;(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

;(setq display-line-numbers-mode t)
;(setq display-line-numbers 'relative)
(set-frame-font "SauceCodePro Nerd Font Mono" nil t)
