#lang racket

(provide empty-stream stream-extend stream-first stream-rest
         stream-take stream-drop stream-append print-stream)

(require (for-syntax racket/base syntax/parse))

(define-syntax-rule (stream-extend lhs rhs)
  (delay (SCons lhs rhs)))

(struct SCons (lhs rhs) #:transparent)

(struct SEmpty () #:transparent)

(define empty-stream (delay (SEmpty)))

(define (stream-first stm)
  (SCons-lhs (force stm)))

(define (stream-rest stm)
  (SCons-rhs (force stm)))

(define (stream-take n stm)
  (delay
   (if (<= n 0)
       (SEmpty)
       (SCons (stream-first stm) (stream-take (- n 1) (stream-rest stm))))))

(define (stream-drop n stm)
  (delay
   (if (<= n 0)
       (force stm)
       (force (stream-drop (- n 1) (stream-rest stm))))))

(define (stream-append s1 s2)
  (delay
    (match (force s1)
      [(SEmpty) (force s2)]
      [(SCons fst rst) (SCons fst (stream-append rst s2))])))

(define (print-stream s)
  (match (force s)
    [(SEmpty) (void)]
    [(SCons fst rst)
     (displayln fst)
     (print-stream rst)]))

;; Examples

(define (fun x)
  (display "x=")
  (displayln x)
  (* x 2))

(define s1 (stream-extend (fun 1) (stream-extend (fun 2) (stream-extend (fun 3) empty-stream))))

(define s2 (stream-append s1 s1))

(print-stream s2)

(define (infinite-build n)
  (stream-extend n (infinite-build (+ n 1))))

(define infinite (infinite-build 1))

(print-stream (stream-take 10 infinite))

(define (sixtyDiv n)
  (stream-extend (/ 60 n) (sixtyDiv (- n 1))))

(define s4 (stream-take 4 (sixtyDiv 4)))
(print-stream s4)
#|
(stream-first s4)
(set! s4 (stream-rest s4))
(stream-first s4)
(set! s4 (stream-rest s4))
(stream-first s4)
(set! s4 (stream-rest s4))
(stream-first s4)
(set! s4 (stream-rest s4))
|#