#lang racket

(module trace racket
  
  (define (trace f . args)
    (printf "Applying ~v to arguments ~v\n" f args)
    (apply f args))
  
  (define-syntax-rule (trace-app f arg ...)
    (trace f arg ...))
  
  (provide (rename-out [trace-app #%app])))
