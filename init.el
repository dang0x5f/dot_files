(set-message-beep 'silent)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(column-number-mode 1)
(global-hl-line-mode 1)
(ido-mode 1)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(load-theme 'xp t t)
(enable-theme 'xp)

(setq make-backup-files nil)

;; (require 'multiple-cursors)
(require 'dired-x)
(require 'magit)

;; cmode
(add-hook 'c-mode-hook
          (lambda ()
            (setq c-basic-offset 4)
            (setq indent-tabs-mode nil)
            (setq tab-width 4)))


;; ---------------- multiple cursors ----------------------------------
;; Start out with:
    (require 'multiple-cursors)
;; Then you have to set up your keybindings - multiple-cursors doesn't presume to
;; know how you'd like them laid out. Here are some examples:
;; When you have an active region that spans multiple lines, the following will
;; add a cursor to each line:
    ;; (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;; When you want to add multiple cursors not based on continuous lines, but based on
;; keywords in the buffer, use:

;; https://github.com/rexim/dotfiles/blob/master/.emacs
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

    ;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
    ;; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    ;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;; First mark the word, then add more cursors.
;; To get out of multiple-cursors-mode, press `<return>` or `C-g`. The latter will
;; first disable multiple regions before disabling multiple cursors. If you want to
;; insert a newline in multiple-cursors-mode, use `C-j`.
;; -------------------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(magit multiple-cursors)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
