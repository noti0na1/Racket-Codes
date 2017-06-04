#lang racket

(struct Tree () #:transparent)

(struct Node Tree (num left right) #:transparent)

(struct Leaf Tree (val) #:transparent)

(struct Digit () #:transparent)

(struct One Digit (tree) #:transparent)

(struct Zero Digit () #:transparent)

(define empty-tree (list (Zero)))

(define (empty-tree? lst)
  (match lst
    [(list (Zero)) #t]
    [_ #f]))

(define (get-number tree)
  (match tree
    [(Leaf _) 1]
    [(Node num _ _) num]))

(define (extend val lst) (extend-helper 1 (Leaf val) lst))

(define (extend-helper n brh lst)
  (match lst
    ['() (list (One brh))]
    [`(,(Zero) ,rt ...) (cons (One brh) rt)]
    [`(,(One tre) ,rt ...)
     (cons (Zero) (extend-helper (* 2 n) (Node (* 2 n) tre brh) rt))]))

(define (first lst)
  (match lst
    ['() 'None]
    [`(,(Zero) ,rt ...) (first rt)]
    [`(,(One tre) ,rt ...) (first-in-tree tre)]))

(define (first-in-tree tree)
  (match tree
    [(Leaf val) val]
    [(Node _ _ rit) (first-in-tree rit)]))

(define (rest lst)
  (match lst
    ['() 'None]
    [`(,(Zero) ,rt ...) (rest rt)]
    [`(,(One tre) ,rt ...) (rest-helper tre rt)]))

(define (rest-helper tree lst)
  (match tree
    [(Leaf _) lst]
    [(Node _ lft rit) (rest-helper rit (cons (One lft) lst))]))

(define (index i lst)
  (match lst
    ['() 'None]
    [`(,(Zero) ,rt ...) (index i rt)]
    [`(,(One tre) ,rt ...)
     (define cn (get-number tre))
     (if (< i cn)
         (index-in-tree i tre)
         (index (- i cn) rt))]))

(define (index-in-tree i tree)
  (match tree
    [(Leaf val) (if (= i 0) val 'None)]
    [(Node n lft rit)
     (if (< i (/ n 2))
         (index-in-tree i rit)
         (index-in-tree (- i (/ n 2)) lft))]))

(extend 0 empty-tree)
(extend 1 (extend 0 empty-tree))
(extend 2 (extend 1 (extend 0 empty-tree)))
(extend 3 (extend 2 (extend 1 (extend 0 empty-tree))))
(extend 4 (extend 3 (extend 2 (extend 1 (extend 0 empty-tree)))))
(extend 5 (extend 4 (extend 3 (extend 2 (extend 1 (extend 0 empty-tree))))))
(extend 6 (extend 5 (extend 4 (extend 3 (extend 2 (extend 1 (extend 0 empty-tree)))))))
(extend 7 (extend 6 (extend 5 (extend 4 (extend 3 (extend 2 (extend 1 (extend 0 empty-tree))))))))

(define l0
  (extend 7 (extend 6 (extend 5 (extend 4 (extend 3 (extend 2 (extend 1 (extend 0 empty-tree)))))))))

(first l0)
(rest l0)
(index 3 l0)