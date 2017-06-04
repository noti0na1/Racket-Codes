#lang racket

(define (trampoline fn . args)
  (if (empty? args)
      (let ([ret (fn)])
        (if (procedure? ret)
            (trampoline ret)
            ret))
      (trampoline (lambda () (apply fn args)))))

(define (bounce fn . args)
  (lambda () (apply fn args)))

(define (my-even? n)
  (if (zero? n)
      #t
      (bounce my-odd? (sub1 (abs n)))))

(define (my-odd? n)
  (if (zero? n)
      #f
      (bounce my-even? (sub1 (abs n)))))

(trampoline my-even? 99999)

