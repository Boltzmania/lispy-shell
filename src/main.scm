;; Constants
(define input-prompt "[In]: ")
(define output-prompt "[Out]: ")

;; Repl function
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (sh-eval input)))
      (announce-output output)))
  (driver-loop))

;; Eval
(define (sh-eval exp)
  (handle-exceptions exn
					 (cond ((equal? ((condition-property-accessor 'exn 'message) exn) "unbound variable")
							(begin (display "do whatever we want next") (newline)))
						   (else (abort exn)))
					 (eval exp)))

;; Printing functions
(define (prompt-for-input string)
  (newline) (newline) (display string)) 

(define (announce-output string)
  (newline) (display output-prompt) (display string) (newline))

;; Main
(driver-loop)
