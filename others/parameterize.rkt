#lang racket

(define x (make-parameter 8))

(define (f) (display (x)) (newline))

(f)

(parameterize ([x 5])
  (f))

(f)