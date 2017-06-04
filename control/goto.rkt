#lang racket/base

(require racket/stxparam (for-syntax racket/base syntax/parse))

(define-syntax-parameter goto (syntax-rules ()))

(begin-for-syntax
  (define-syntax-class thunk
    (pattern (lab:id body:expr ...))))

(define-syntax (prog stx)
  (syntax-parse stx
    [(_) #'(void)]
    [(_ ((~literal label) l:id) exp:expr ...)
     #'(prog0 () (label l) exp ...)]
    [(_ exp:expr ...)
     #'(prog0 () (label start0) exp ...)]))

(define-syntax (prog0 stx)
  (syntax-parse stx
    [(_ (t ... (lab1)))
     #'(prog1 (t ... (lab1 (void))))]
    [(_ (t ...))
     #'(prog1 (t ...))]
    [(_ () ((~literal label) lab1:id) exp ...)
     #'(prog0 ((lab1)) exp ...)]
    [(_ (t ... t1:thunk) ((~literal label) lab1:id) exp ...)
     #'(prog0 (t ... (t1.lab t1.body ... (lab1)) (lab1)) exp ...)]
    [(_ (t ... t1:thunk) exp0 exp ...)
     #'(prog0 (t ... (t1.lab t1.body ... exp0)) exp ...)]))

(define-syntax (prog1 stx)
  
  (define-syntax-class thunks-with-distinct-label
    (pattern (t:thunk ...)
             #:fail-when (check-duplicate-identifier
                          (syntax->list #'(t.lab ...)))
             "duplicate label names"
             #:with (lab ...) #'(t.lab ...)
             #:with (body ...) #`((begin t.body ...) ...)))
  
  (syntax-parse stx
    [(_ ts:thunks-with-distinct-label)
     #`((let/cc k
          (syntax-parameterize ([goto (syntax-rules ()
                                        [(_ w) (k w)])])
            (letrec ([ts.lab (lambda () ts.body)] ...)
              #,(car (syntax->list #'(ts.lab ...)))))))]))

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

