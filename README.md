# Racket-Codes

A Collection of My Racket Code

## Control

### flow.rkt

Put function calls in a streaming fashion

```racket
(>> 3 (λ (x) (+ x 2)) (λ (x) (+ x 3)))

(define (fun0 x y)
  (values (+ x y) (- x y)))

(define p0 (-> fun0 (-> fun0) fun0))

((-> (inject 2 3) p0))
```

### goto.rkt

Add goto/label into Racket

```racket
(prog
 (displayln 1)
 (goto lb0)
 (displayln 5)
 (label lb1)
 (displayln 3)
 (goto end)
 (label lb0)
 (displayln 2)
 (goto lb1)
 (label end))
```

### trampoline.rkt

A simple implement of trampoline

```
(define (my-even? n)
  (if (zero? n)
      #t
      (bounce my-odd? (sub1 (abs n)))))

(define (my-odd? n)
  (if (zero? n)
      #f
      (bounce my-even? (sub1 (abs n)))))

(trampoline my-even? 99999)
```

### while-loop.rkt

Implement while loop using macro and cc, support continue and break

```racket
(let ([a 1])
  (while (< a 10)
         (set! a (+ a 1))
         (let ([b 1])
           (while (< b a)
                (display b)
                (display " ")
                (set! b (+ b 1))
                (when (= b 5) (break)))
         (display a)
         (display " "))))
```

## Data Structure

### braun-tree.rkt

Implement of Braun Tree

### BTrees.rkt

Implement traversing Binary Tree in different styles (CPS)

### PBLT.rkt

//PBLT

### stream.rkt

A simple implement of stream

```racket
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
```

## Others

### self-reproducing

```
#lang racket

;; "Ω"

((λ (x) `(,x ',x)) '(λ (x) `(,x ',x)))

;; call/cc

(call/cc
 (lambda (c)
   (c ((lambda (c) `(call/cc (lambda (c) (c (,c ',c)))))
       '(lambda (c) `(call/cc (lambda (c) (c (,c ',c)))))))))

;; print

(let ([a "#lang racket\n\n(let ([a ~s]))\n  (printf a a))"])
  (printf a a))
```

### function-keyword.rkt

Using keywords in function definition

```racket
(fun #:mode 3 2 3)
```

### list-comprehension.rkt

Implement list comprehension

```racket
;; [x * y | x <- [-1, 2, -4, 4], x > 0, y <- [10, 20, 30], x * y < 50]
(listc (* x y) for (x <- (list -1 2 -3 4)) (> x 0) (y <- (list 10 20 30)) (< (* x y) 50))

;; [[x, y, z] | x <- [1, 2, 3], y <- [4, 5], z <- [6]]
(listc (list x y z) for (x <- (list 1 2 3)) (y <- (list 4 5)) (z <- (list 6)))
```

### parmeterize.rkt

Use of parameterize

### trace.rkt

Trace function calls (from internet)

### sweet.rkt

Simple example of sweet-expression

```racket
#lang sweet-exp racket

define add(x y)
    {x + y}

define mult(x y)
    {x * y}

define fun(x y)
    if {x < y}
       add(x y)
       mult(x y)

fun(2 3)
fun(3 2)
```

### comments.rkt

examples of different types of comments

```racket
#lang racket

;   single
;;  line
;;; coments

#| block
   comments
|#

#;(define (fun x)
    (s-exp comments))

#! /bin/sh

```