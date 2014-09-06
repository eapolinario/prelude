;; defvar is the correct way to declare global variables
;; you might see setq as well, but setq is supposed to be use just to set variables,
;; not create them.
(defvar required-packages
  '(
    key-chord
    rainbow-identifiers
    xclip
  ) "a list of packages to ensure are installed at launch.")

;; method to check if all packages are installed
(defun packages-installed-p ()
  (loop for p in required-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

;; if not all packages are installed, check one by one and install the missing ones.
(unless (packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p required-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; Rainbow identifiers mode!
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)

;; Match parenthesis
(show-smartparens-global-mode +1)

;; Transparently open compressed files
(auto-compression-mode t)

;; Copying/Cutting in console emacs will add it to your mac clipboard
;; Need to also "sudo yum install xclip" along with installing xcip.el
;; Need to also enable X11 Forwarding & trusted X11 Forwarding (ssh -X -Y)
;; TODO: is this just for when we're loading with X?
;; (require 'xclip)
;; (turn-on-xclip)
(if (boundp 'xclip) (require 'xclip))
(if (boundp 'xclip) (turn-on-xclip))

;; To enable mouse interaction when running emacs on iterm 2
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  )

(when window-system
  ;; enable wheelmouse support by default
  (mwheel-install)
  ;; use extended compound-text coding for X clipboard
  (set-selection-coding-system 'compound-text-with-extensions)
  (setq x-select-enable-clipboard t)
  (setq interprogram-paste-function 'x-cut-buffer-or-selection-value))

;; Paste a giant string to current buffer
;; Thank Chao for it :)
(defun ins ()
  (interactive)
  (let* ((target (current-buffer))
         (buffer (generate-new-buffer (format "*Paste Buffer for <%s>*"
                                              (buffer-name target)))))
    (with-current-buffer buffer
      (make-local-variable 'ins-target-buffer)
      (setq ins-target-buffer target)
      (local-set-key "\C-c\C-c"
                     '(lambda ()
                        (interactive)
                        (let ((buffer (current-buffer)))
                          (switch-to-buffer ins-target-buffer)
                          (insert-buffer-substring buffer)
                          (kill-buffer buffer))))
      (local-set-key "\C-c\C-k"
                     '(lambda ()
                        (interactive)
                        (let ((buffer (current-buffer)))
                          (switch-to-buffer ins-target-buffer)
                          (kill-buffer buffer)))))
    (switch-to-buffer buffer)
    (message (format "Enter a text to paste.  Type C-c C-c when done. (C-c C-k to dismiss)"
                     (buffer-name target)))))

;; Key-chord stuff
(require 'key-chord)
(key-chord-mode 1)

(key-chord-define-global "mx" 'execute-extended-command)
(key-chord-define-global "IT" 'insert-timestamp)
(key-chord-define-global "NN" 'scroll-up-command)
(key-chord-define-global "PP" 'scroll-down-command)

;; Window move
;; TODO find a way to detect you're in 'terminal-mode', and if so,
;; rebind window-navigation
;; (global-set-key (kbd "C-x <up>") 'windmove-up)
;; (global-set-key (kbd "C-x <down>") 'windmove-down)
;; (global-set-key (kbd "C-x <right>") 'windmove-right)
;; (global-set-key (kbd "C-x <left>") 'windmove-left)

;; Enable forward/backward word on OSX
;; (global-set-key '[(meta right)] 'forward-word)
;; (global-set-key '[(meta left)] 'backward-word)

;; "cat -vt" is your friend
;; (define-key input-decode-map "\e[1;3C" [(meta right)])
;; (define-key input-decode-map "\e[1;3D" [(meta left)])
