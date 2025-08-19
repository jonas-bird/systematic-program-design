#lang htdp/bsl
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

;; 348 now we add in Boolean

;; boolval is one of:
;; - #true
;; - #false

(define-struct myAND (left right))
(define-struct myOR (left right))
(define-struct myNOT (clause))
;; NOTE: I am not sure if I like this as a final definition, maybe and/or should be able to handle more than 2 arguments?
;; boolexp is one of:
;; - boolval
;; - (make-myAND [boolexp boolexp])
;; - (make-myOR [boolexp boolexp])
;; - (make-myNOT [bookexp])

;; boolexp -> Boolean
;; eval-bool-expression evaluates a boolean expression to a boolean value
(check-expect (eval-bool-expression #true) #true)
(check-expect (eval-bool-expression (make-myNOT #true)) #false)
(check-expect (eval-bool-expression (make-myAND #false #false)) #false)
(check-expect (eval-bool-expression (make-myAND #true #false)) #false)
(check-expect (eval-bool-expression (make-myAND #true #true)) #true)
(check-expect (eval-bool-expression (make-myAND (make-myNOT #false) #false)) #false)
(check-expect (eval-bool-expression (make-myOR #false #true)) #true)
(check-expect (eval-bool-expression (make-myOR #false #false)) #false)
(check-expect (eval-bool-expression (make-myOR (make-myAND #true #true)
                                               (make-myNOT (make-myOR #false #true)))) #true)
(check-expect (eval-bool-expression #true) #true)
;(define (eval-bool-expression b) #false) ;stub
(define (eval-bool-expression b)
    (match b
      ((? boolean?) b)
      ((myAND x y) (and (eval-bool-expression x) (eval-bool-expression y)))
      ((myOR x y) (or (eval-bool-expression x) (eval-bool-expression y)))
      ((myNOT x) (not (eval-bool-expression x)))))
