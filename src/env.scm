;;; Library sh-env
(declare (unit sh-env))

;; Table Objects
(define (make-table)
  (let ((table (list '*table*)))
	(define (lookup key)
	  (let ((record (assoc key (cdr table))))
		(if record
		  (cdr record)
		  'key-not-found)))

	(define (insert! key value)
	  (let ((record (assoc key (cdr table))))
		(if record
		  (set-cdr! record value)
		  (set-cdr! table
					(cons (cons key value) (cdr table)))))
	  'done)
	(define (dispatch method)
	  (cond ((eq? method 'lookup) lookup)
			((eq? method 'insert!) insert!)
			(else (error "Unknown method call --- TABLE" method))))
	dispatch))

;; Environment
(define *env* (make-table))
(define (env-get key)
  ((*env* 'lookup) key))
(define (env-set! key value)
  ((*env* 'insert!) key value))

;; Env variables
(env-set! 'input-prompt "[In]: ")
(env-set! 'output-prompt "[Out]: ")
(env-set! 'current-dir "/")
(env-set! 'prev-dir "/")
(env-set! 'home "/")
(env-set! 'path (list "/usr/bin" "/bin"))
