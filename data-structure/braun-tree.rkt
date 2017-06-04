#lang racket

(struct Node (val left right) #:transparent)

(define (extend val tree)
  (match tree
    ['() (Node val empty empty)]
    [(Node v l r) (Node val (extend v r) l)]))

(define (first tree)
  (match tree
    ['() 'None]
    [(Node v l r) v]))

(define (rest tree)
  (match tree
    ['() 'None]
    [(Node _ '() '()) empty]
    [(Node _ (and lt (Node lv _ _)) rt)
     (Node lv rt (rest lt))]))

(define (index i tree)
  (unless (>= i 0) (error "i should greater or equal to 0"))
  (match tree
    ['() 'None]
    [(Node v l r)
     (cond
       [(= i 0) v]
       [(even? i) (index ((i . - . 2) . / . 2) r)]
       [else (index ((i . - . 1) . / . 2) l)])]))

(define t0 (extend 'd (extend 'c (extend 'b (extend 'a empty)))))

t0

(first t0)
(rest t0)
(extend 'd (rest t0))
(index 2 t0)
