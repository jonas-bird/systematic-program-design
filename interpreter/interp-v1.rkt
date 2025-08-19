(require 2htdp/abstraction)

;;; 345

;mathexp is one of
; - Number
; - (make-add [mathxp mathxp])
; - (make-mul [mathxp mathxp])


;; first try for a data-definition for addition and multiplication
(define-struct add [left right])
(define-struct mul [left right])

; examples:
; BSL                   representation
; 3                     3
; (+ 1 1)              (make-add 1 1)
; (* 3000 1000)        (make-mul 3000 1000)
;
;
; more complex:
; (+ (* 1 1) 10)    (make-add (make-mul 1 1) 10)



;; 346 data definition for the class of values
;; to which a representation of a BSL expression can evaluate.
;; So far we have defined a BSL-value as a number
;; the full definition would include:
;; - Number
;; - Boolean
;; - String
;; - Image
;; - '()
;; - (cond expression '())
;; - struct

;; 347 eval-expression

;; mathexp -> Number
;; evaluate a simple expression
(check-expect (eval-expression (make-add 2 1)) (+ 2 1))
(check-expect (eval-expression (make-mul 2 2)) (* 2 2))
(check-expect
 (eval-expression (make-add (make-mul 2 4) (make-add 1 3)))
 (+ (* 2 4) (+ 1 3)))
;(define (eval-expression e) 0);

(define (eval-expression e)
  (match e
    [(? number?) e]
    [(add x y) (+ (eval-expression x) (eval-expression y))]
    [(mul x y) (* (eval-expression x) (eval-expression y))]))
