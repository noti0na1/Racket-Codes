#lang racket

(require lens)

(define id (lambda (i) i))

(struct Node (key value left right) #:transparent)

(define (toTree src)
  (match src
    [(list key value left right)
     (Node key value (toTree left) (toTree right))]
    ['/ empty]))

(define (traverse fun tree)
  (match tree
    [(Node key value left right)
     (fun key value (traverse fun left) (traverse fun right))]
    ['() '()]))

(define (tmap fun tree) (traverse (lambda (k v l r) (Node k (fun k v) l r)) tree))

(define (tree->assoc tree)
  (traverse (lambda (k v l r) (append l (cons (list k v) r))) tree))

(define (traverse/k fun tree k)
  (match tree
    [(Node key value left right)
     (traverse/k fun left
                 (lambda (r1)
                   (traverse/k fun right
                               (lambda (r2)
                                 (k (fun key value r1 r2))))))]
    ['() (k '())]))

(define (tmap/k fun tree) (traverse/k (lambda (k v l r) (Node k (fun k v) l r)) tree id))

(define (tree->assoc/k tree)
  (traverse/k (lambda (k v l r) (append l (cons (list k v) r))) tree id))

(struct CNodeL (key value right cont))

(struct CNodeR (key value left cont))

(define (traverse/cp fun tree)
  (define (go tr cont)
    (match tr
      [(Node key value left right)
       (go left (CNodeL key value right cont))]
      [_ (eval cont tr)]))
  (define (eval cont val)
    (match cont
      [(CNodeL key value right k)
       (go right (CNodeR key value val k))]
      [(CNodeR key value left k)
       (eval k (fun key value left val))]
      ['() val]))
  (go tree empty))

(define (tmap/cp fun tree) (traverse/cp (lambda (k v l r) (Node k (fun k v) l r)) tree))

(define (tree->assoc/cp tree)
  (traverse/cp (lambda (k v l r) (append l (cons (list k v) r))) tree))

(define (tree-size/cp tree)
  (traverse/cp
   (lambda (k v l r)
     (+ 1 (if (empty? l) 0 l) (if (empty? r) 0 r)))
   tree))

(define t0 (toTree '(5 10 (1 2 / (4 8 / /)) (8 16 (6 12 / (7 14 / /)) /))))
t0

(tmap (lambda (k v) (* 2 v)) t0)

(tmap/k (lambda (k v) (* 3 v)) t0)

(tmap/cp (lambda (k v) (* 4 v)) t0)

(tree->assoc t0)

(tree->assoc/k t0)

(tree->assoc/cp t0)

(tree-size/cp t0)