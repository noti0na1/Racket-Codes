#lang racket

(define (id . args) (apply values args))

(define (inject . args) (lambda () (apply values args)))

(define (print-args . args)
  (display args)
  (newline)
  (apply values args))

(define (flow procs)
  (if (empty? procs)
      id
      (lambda args
        (call-with-values
         (lambda () (apply (first procs) args))
         (flow (rest procs))))))

(define (flow-trace procs)
  (flow (foldr (lambda (n acc) (list* print-args n acc)) empty procs)))

(define (-> . procs) (flow procs))

(define (t-> . procs) (flow-trace procs))


(define (fun0 x y)
  (values (+ x y) (- x y)))

(define p0 (-> fun0 (-> fun0) fun0))

((t-> (inject 2 3) p0))


