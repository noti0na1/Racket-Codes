#lang racket/base

(require (for-syntax racket/base syntax/parse))

(define-syntax (listc stx)
  (syntax-parse stx
    #:datum-literals (for)
    [(_ out:expr for rt ...)
     #'(listc0 '() out for rt ...)]))

(define-syntax (listc0 stx)
  (syntax-parse stx
    #:datum-literals (for <-)
    [(_ lst out for)
     #'(cons out lst)]
    [(_ lst out for (var:id <- in:expr) rt ...)
     #'(foldr (lambda (var lst0) (listc0 lst0 out for rt ...)) lst in)]
    [(_ lst out for pre:expr rt ...)
     #'(if pre (listc0 lst out for rt ...) lst)]))

(listc (* x y) for (x <- (list -1 2 -3 4)) (> x 0) (y <- (list 10 20 30)) (< (* x y) 50))

(listc (list x y z) for (x <- (list 1 2 3)) (y <- (list 4 5)) (z <- (list 6)))