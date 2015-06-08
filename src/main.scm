;; Init
;(require-library utils)
;(import (prefix utils utils:))
(use utils)

;; Environment
(define input-prompt "[In]: ")
(define output-prompt "[Out]: ")
(define done #f)
(define current-dir "/")
(define prev-dir "/")
(define home "/")
(define path (list "/usr/bin" "bin"))

;; Read
(define (prompt-for-input string)
  (newline) (newline) (display string)) 

;; Eval
; functions
(define (cd . dir)
  (if (= 0 (length dir))
	(cd home)
	(if (eqv? (car dir) '-)
	  (cd prev-dir)
	  (begin (set! prev-dir current-dir)
			 (change-directory dir)
			 (set! current-dir dir)))))
(define pwd
  (lambda () (current-directory)))
(define exit
  (lambda () (set! done #t)))

(define (accumulate op initial sequence)
  (if (null? sequence)
	initial
	(op (car sequence)
		(accumulate op initial (cdr sequence)))))

(define (any->string thing)
  (cond ((string? thing) thing)
		((symbol? thing) (symbol->string thing))
		((number? thing) (number->string thing))))

(define (list->command lst)
  (accumulate (lambda (str1 str2)
				(string-append (any->string str1) " " (any->string str2)))
			  ""
			  lst))

(define (fail-gracefully exn)
  (display "Exception occurred: ")
  (display ((condition-property-accessor 'exn 'message) exn))
  (newline))

; eval
(define (sh-eval exp)
  (handle-exceptions exn
					 (cond ((equal? ((condition-property-accessor 'exn 'message) exn) "unbound variable")
							(let ((command (list->command exp)))
							  (system command)))
							;(begin (display "do whatever we want next") (newline)))
						   (else (fail-gracefully exn)))
					 (eval exp)))

;; Print
(define (announce-output string)
  (newline) (display output-prompt) (display string) (newline))

;; REPL
(define (repl)
  (define (driver-loop)
	(prompt-for-input input-prompt)
	(let ((input (read)))
	  (let ((output (sh-eval input)))
		(announce-output output)))
	(repl))
  (if (not done)
	(driver-loop)
	'done))

;; Main
(repl)
