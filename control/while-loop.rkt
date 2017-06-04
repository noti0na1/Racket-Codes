#lang racket/base

(require racket/stxparam (for-syntax racket/base syntax/parse))

(define-syntax-parameter break (syntax-rules ()))

(define-syntax-parameter continue (syntax-rules ()))

(define-syntax (while stx)
  (syntax-parse stx
    [(_ test body:expr ...)
     #'(let/cc k1
         (let ([t (void)])
           (begin
             (let/cc k2 (set! t k2))
             (syntax-parameterize
                 ([break (syntax-rules () [(_) (k1 (void))])]
                  [continue (syntax-rules () [(_) (t (void))])])
               (when (not test) (break))
               body ...
               (continue)))))]))

(let ([a 1])
  (while (< a 10)
         (set! a (+ a 1))
         (display a)))

(newline)

(let ([a 1])
  (while (< a 10)
         (set! a (+ a 1))
         (when (= a 5) (break))
         (display a)))

(newline)

(let ([a 1])
  (while (< a 10)
         (set! a (+ a 1))
         (when (= a 5) (continue))
         (display a)))

(newline)

(let ([a 1])
  (while (< a 10)
         (set! a (+ a 1))
         (let ([b 1])
           (while (< b a)
                (display b)
                (display " ")
                (set! b (+ b 1))
                (when (= b 5) (break))
                )
         (display a)
         (display " "))))