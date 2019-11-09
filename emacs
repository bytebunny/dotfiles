(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-electric-sub-and-superscript 1)
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(blink-cursor-mode nil)
 '(custom-enabled-themes (quote (deeper-blue)))
 '(electric-indent-mode nil)
 '(f90-continuation-indent 7)
 '(f90-do-indent 4)
 '(f90-if-indent 4)
 '(f90-program-indent 4)
 '(f90-type-indent 4)
 '(fortran-line-number-indent 1)
 '(global-linum-mode t)
 '(ido-enable-flex-matching nil)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(markdown-command "/usr/local/bin/pandoc")
 '(menu-bar-mode nil)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(package-selected-packages
   (quote
    (auctex-latexmk exec-path-from-shell markdown-preview-mode dired+ dired-quick-sort ssh markdown-mode+ jedi gh-md flycheck el-get column-enforce-mode auto-complete-auctex auctex ac-math ac-ispell 0blayout)))
 '(python-shell-interpreter "python")
 '(require (quote auto-complete))
 '(send-mail-function (quote mailclient-send-it))
 '(tab-width 4)
 '(tool-bar-mode nil))
; Make buffer names of the files with identical names unique:
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)
(setq-default indent-tabs-mode nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#181a26" :foreground "gray80" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "Menlo"))))
 '(flyspell-duplicate ((t (:foreground "yellow1" :underline "red2" :weight bold))))
 '(flyspell-incorrect ((t (:foreground "red2" :underline "yellow1" :weight bold)))))
;; start auto-complete section:
;;(add-to-list 'load-path "~/.emacs.d/ac/")
(package-initialize) ;; instead of adding load path (see previous line)
(require 'exec-path-from-shell) ; Get $PATH from the terminal.
(when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize))
(when (not package-archive-contents)
    (package-refresh-contents))  ; Update the list of available packages.
(require 'ac-math) ;; this package has to be installed beforehand
(add-to-list 'load-path "~/.emacs.d/ac")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac/ac-dict")
(ac-config-default)
(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`
(defun ac-LaTeX-mode-setup () ; add ac-sources to default ac-sources
   (setq ac-sources
         (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
                 ac-sources))
   )
(add-hook 'LaTeX-mode-hook 'ac-LaTeX-mode-setup)
(global-auto-complete-mode t)
(setq ac-disable-faces nil) ; Turns on auto-complete inside of quote marks and comments.
(setq ac-math-unicode-in-math-p t)
;; end auto-complete section.
;; add path to the TeX distribution:
(setenv "PATH" (concat "/Library/TeX/texbin/:" (getenv "PATH")))
;; add path to the Ghostscript:
(setenv "PATH" (concat "/opt/local/bin/:" (getenv "PATH")))
;; allow dired to be able to delete or copy a whole dir.
(setq dired-recursive-copies (quote always)) ; “always” means no asking
(setq dired-recursive-deletes 'always)
(require 'auto-complete-auctex) ; Package has to be installed.
;; auctex recommended preferences (auctex package has to be already installed):
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
; Automatically insert ‘$...$’ in plain TeX files, and ‘\(...\)’ in LaTeX files by pressing $ (AUCTeX is needed):
(add-hook 'plain-TeX-mode-hook
	  (lambda () (set (make-variable-buffer-local 'TeX-electric-math)
			  (cons "$" "$"))))
(add-hook 'LaTeX-mode-hook
	  (lambda () (set (make-variable-buffer-local 'TeX-electric-math)
			  (cons "\\(" "\\)"))))
; In AUCTeX, get a full featured 'LaTeX-section' command:
(setq LaTeX-section-hook
      '(LaTeX-section-heading
        LaTeX-section-title
        LaTeX-section-toc
        LaTeX-section-section
        LaTeX-section-label))
;(setq preview-gs-command "/usr/local/bin/gs") ; populate variable to enable preview of pdftex within Emacs.
; Activate RefTeX and make it interact with AUCTeX:
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;Open .py and .pyw in python-mode
(setq auto-mode-alist
      (cons '("\\.\\(py\\|pyw\\)$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist
      (cons '("python" . python-mode)
            interpreter-mode-alist))
(require 'epc)
(add-to-list 'load-path "/usr/local/bin/virtualenv")
(add-to-list 'load-path "~/.emacs.d/elpa/jedi-20160425.2156/")
(add-hook 'python-mode-hook 'jedi:setup) ; Setup jedi. Note: it was producing
                                        ; an error untill I downloaded the
                                        ; latest jedi.el (https://github.com/tkf/emacs-jedi)
                                        ; and installed Python server (jediepcserver.py).
(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)
;; Open *.m files with Matlab mode (matlab-mode package has to be already installed):
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
 (add-to-list
  'auto-mode-alist
  '("\\.m$" . matlab-mode))
 (setq matlab-indent-function t)
 (setq matlab-shell-command "matlab")
(add-hook 'matlab-mode-hook 'auto-complete-mode) ; Toggle auto-complete mode when entering matlab mode.
(add-hook 'matlab-mode-hook 'column-enforce-mode 1) ; Enable 80 column rule in Matlab.
; CLI matlab from the shell:
; /Applications/MATLAB_R2016a.app/bin/matlab -nodesktop
; elisp setup for matlab-mode:
(setq matlab-shell-command "/Applications/MATLAB_R2016b.app/bin/matlab")
(setq matlab-shell-command-switches (list "-nodesktop"))
; Enable 'column-enforce-mode' globally ('column-enforce-mode' has to be already installed):
(add-to-list 'load-path "~/.emacs.d/elpa/column-enforce-mode-20140902.949/")
(require 'column-enforce-mode)
(global-column-enforce-mode t) ; Enable globally. By default enforces 80 column rule.
; (setq column-enforce-comments nil) ; Allow long comments.
(setq column-number-mode t) ; Enable column number mode.
(setq ispell-program-name "/usr/local/bin/ispell") ; Give path to Ispell (it has to be already installed).
(add-hook 'LaTeX-mode-hook 'flyspell-mode) ; Enable flyspell-mode for LaTeX files.
(add-hook 'python-mode-hook 'flyspell-prog-mode) ; Enable flyspell-prog-mode
                                        ; for Python mode.
; If flyspell-mode fails to start, try downloading a new copy from the web,
; bit-compile it, find old copies on the system and replace with the new
; compiled file. Make sure the name is 'flyspell.elc'!
(ac-flyspell-workaround) ; Avoid disabling auto-completion when using
; flyspell-mode.
(setq exec-path (append exec-path
'("/usr/local/texlive/2017/bin/x86_64-darwin/"))) ; AUCTeX could not find kpsewhich,
; so I had to give the path. WARNING: with the future TeXLive versions the path will have to change. This
; workaround might not be necessary if the "linking" is done properly: for some reason
; AUCTeX refused to use kpsewhich located in the system path.
(setq dired-dwim-target t) ; Make Dired guess the target directory.
; Point to GNU version of 'ls' (needed for sorting in dired-mode; can be
; installed using Homebrew by running 'brew install coreutils' in terminal):
(setq insert-directory-program "/usr/local/bin/gls") 
; Do NOT hide details in Dired from the outset (must be set before loading
; dired+.el):
(setq diredp-hide-details-initially-flag nil)
(require 'dired+)
; Enable sorting of Dired buffer in various ways (press "S" in dired-mode
; to invoke):
(require 'dired-quick-sort)
(dired-quick-sort-setup)
(setq dired-listing-switches "-alh") ; Add '-h' flag to have human-readable
                                     ; format (size in units of B, K, M, G as
                                     ; appropriate).
(savehist-mode 1) ; Enable this mode to save settings of dired-mode.
;; add path to gnuplot:
(setenv "PATH" (concat "/usr/local/bin/:" (getenv "PATH")))
(require 'auctex-latexmk)
(auctex-latexmk-setup)
(setenv "LANG" "en_US.UTF-8") ; Make LuaTeX recognise locale.
(setenv "LC_ALL" "en_US.UTF-8")
; Disable linum-mode in listed modes:
(define-globalized-minor-mode my-global-linum-mode linum-mode
  (lambda ()
    (unless (or (minibufferp)
                (derived-mode-p 'doc-view-mode 'shell-mode))
      (linum-mode 1))))
(my-global-linum-mode 1)
(toggle-frame-fullscreen) ; Start fullscreen mode.
