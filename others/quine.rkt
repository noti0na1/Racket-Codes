#lang racket

(call/cc
 (lambda (c)
   (c ((lambda (c) `(call/cc (lambda (c) (c (,c ',c)))))
       '(lambda (c) `(call/cc (lambda (c) (c (,c ',c)))))))))

(let ([a "#lang racket\n\n(let ([a ~s]))\n  (printf a a))"])
  (printf a a))