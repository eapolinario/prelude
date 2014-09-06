
;; Window move
;; TODO find a way to detect you're in 'terminal-mode', and if so,
;; rebind window-navigation
;; (global-set-key (kbd "C-x <up>") 'windmove-up)
;; (global-set-key (kbd "C-x <down>") 'windmove-down)
;; (global-set-key (kbd "C-x <right>") 'windmove-right)
;; (global-set-key (kbd "C-x <left>") 'windmove-left)

;; Enable forward/backward word on OSX
(global-set-key '[(meta right)] 'forward-word)
(global-set-key '[(meta left)] 'backward-word)

;; "cat -vt" is your friend
;; (define-key input-decode-map "\e[1;3C" [(meta right)])
;; (define-key input-decode-map "\e[1;3D" [(meta left)])

