;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname dict) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/abstraction)
; On OS X: 
(define LOCATION "/usr/share/dict/words")
; On LINUX: /usr/share/dict/words or /var/lib/dict/words
; On WINDOWS: borrow the word file from your Linux friend

; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))

; A Dictionary is a List-of-strings.
;(define AS-LIST (read-lines LOCATION))

;; test data
(define TEST-LOC "small-dict.txt")
(define TEST-LIST (read-lines TEST-LOC))

;;; exercise 195: design a function starts-with# to answer how many words in a dictionary
;;;               start with a given letter

;; Letter [List-of String] -> Number
(check-expect (starts-with# "a" (list "apple" "ardvark" "bat"  "cow")) 2)
(check-expect (starts-with# "z" '()) 0)
(check-expect
 (starts-with# "c" (list "apple" "bat" "cow" "dog" "tactical")) 1)
;(define (starts-with# c los) 0);stub
(define (starts-with# c los)
  (cond [(empty? los) 0]
        [else
         (if (string=? c (first (explode (first los))))
             (add1 (starts-with# c (rest los)))
             (starts-with# c (rest los)))]))

(define ex195a (starts-with# "e" TEST-LIST)) ;3296
(define ex195b (starts-with# "z" TEST-LIST)) ;146

;; 196
;; [List-of String] -> [List-of Number]
;; count how often each letter is used as the first one of a word in a given dictionary
(check-expect (count-by-letter TEST-LIST)
              (list '("a" 261) '("b" 195) '("c" 384)
                    '("d" 213) '("e" 192) '("f" 181)
                    '("g" 125) '("h" 131) '("i" 140)
                    '("j" 24)  '("k" 31)  '("l" 135)
                    '("m" 164) '("n" 77)  '("o" 93)
                    '("p" 318) '("q" 15)  '("r" 209)
                    '("s" 458) '("t" 225) '("u" 81)
                    '("v" 38)  '("w" 136) '("x" 0)
                    '("y" 14)  '("z" 2)))
(check-expect (count-by-letter (list "a" "b" "c" "d" "e" "f" "g" "h")) (list '("a" 1) '("b" 1) '("c" 1) '("d" 1) '("e" 1) '("f" 1) '("g" 1) '("h" 1) '("i" 0) '("j" 0) '("k" 0) '("l" 0) '("m" 0) '("n" 0) '("o" 0) '("p" 0) '("q" 0) '("r" 0) '("s" 0) '("t" 0) '("u" 0) '("v" 0) '("w" 0) '("x" 0) '("y" 0) '("z" 0)))
;(define (count-by-letter los) '()) ;stub

(define (count-by-letter los)
   (for/list ([c LETTERS])
     (starts-with# c los)))

;; 197
;; [List-of String] -? Number 