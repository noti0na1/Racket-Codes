#lang racket

;; "Ω"

((λ (x) `(,x ',x)) '(λ (x) `(,x ',x)))

((lambda (h) (write `(,h ',h))) '(lambda (h) (write `(,h ',h))))

;; call/cc

(call/cc
 (lambda (c)
   (c ((lambda (c) `(call/cc (lambda (c) (c (,c ',c)))))
       '(lambda (c) `(call/cc (lambda (c) (c (,c ',c)))))))))

;; print

(let ([a "#lang racket\n\n(let ([a ~s]))\n  (printf a a))"])
  (printf a a))