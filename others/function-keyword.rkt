#lang racket

(define (fun #:mode [mode 1] x y)
  (cond
    [(= mode 1) (+ x y)]
    [(= mode 2) (* x y)]
    [else (list x y)]))

(fun 2 3)

(fun #:mode 2 2 3)

(fun #:mode 3 2 3)