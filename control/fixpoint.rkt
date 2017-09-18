#lang racket

(define rec
  (λ (f) ((λ (x) (λ a (apply (f (x x)) a)))
          (λ (x) (λ a (apply (f (x x)) a))))))

(define fun
  (rec (λ (fun)
         (λ (x)
           (if (= x 0) 1 (* x (fun (- x 1))))))))

(fun 10)