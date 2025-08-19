;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname dict) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

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
(define TEST-SMALL (list "apple" "argument" "bat" "cat" "orange" "zebra"))

(define-struct letter-count [letter count])
; A Letter-Count is (make-letter-count Letter Natural)
; interp. (make-letter-count etterl count) indicates that letter appears count times
(make-letter-count "A" 5)

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
;; [List-of String] -> [List-of Letter-Count]
;; count how often each letter is used as the first one of a word in a given dictionary
(check-expect (count-by-letter '() TEST-LIST) '())
(check-expect (count-by-letter LETTERS '()) (list
                                             (make-letter-count "a" 0)
                                             (make-letter-count "b" 0)
                                             (make-letter-count "c" 0)
                                             (make-letter-count "d" 0)
                                             (make-letter-count "e" 0)
                                             (make-letter-count "f" 0)
                                             (make-letter-count "g" 0)
                                             (make-letter-count "h" 0)
                                             (make-letter-count "i" 0)
                                             (make-letter-count "j" 0)
                                             (make-letter-count "k" 0)
                                             (make-letter-count "l" 0)
                                             (make-letter-count "m" 0)
                                             (make-letter-count "n" 0)
                                             (make-letter-count "o" 0)
                                             (make-letter-count "p" 0)
                                             (make-letter-count "q" 0)
                                             (make-letter-count "r" 0)
                                             (make-letter-count "s" 0)
                                             (make-letter-count "t" 0)
                                             (make-letter-count "u" 0)
                                             (make-letter-count "v" 0)
                                             (make-letter-count "w" 0)
                                             (make-letter-count "x" 0)
                                             (make-letter-count "y" 0)
                                             (make-letter-count "z" 0)))
(check-expect (count-by-letter LETTERS TEST-LIST)
              (list (make-letter-count "a" 261)
                    (make-letter-count "b" 195)
                    (make-letter-count "c" 384)
                    (make-letter-count "d" 213)
                    (make-letter-count "e" 192)
                    (make-letter-count "f" 181)
                    (make-letter-count "g" 125)
                    (make-letter-count "h" 131)
                    (make-letter-count "i" 140)
                    (make-letter-count "j" 24)
                    (make-letter-count "k" 31)
                    (make-letter-count "l" 135)
                    (make-letter-count "m" 164)
                    (make-letter-count "n" 77)
                    (make-letter-count "o" 93)
                    (make-letter-count "p" 318)
                    (make-letter-count "q" 15)
                    (make-letter-count "r" 209)
                    (make-letter-count "s" 458)
                    (make-letter-count "t" 225)
                    (make-letter-count "u" 81)
                    (make-letter-count "v" 38)
                    (make-letter-count "w" 136)
                    (make-letter-count "x" 0)
                    (make-letter-count "y" 14)
                    (make-letter-count "z" 2)))
(check-expect
 (count-by-letter
  LETTERS (list "a" "b" "c" "c" "d" "e" "f" "g" "h"))
 (list (make-letter-count "a" 1) (make-letter-count "b" 1)
       (make-letter-count "c" 2) (make-letter-count "d" 1)
       (make-letter-count "e" 1) (make-letter-count "f" 1)
       (make-letter-count "g" 1) (make-letter-count "h" 1)
       (make-letter-count "i" 0) (make-letter-count "j" 0)
       (make-letter-count "k" 0) (make-letter-count "l" 0)
       (make-letter-count "m" 0) (make-letter-count "n" 0)
       (make-letter-count "o" 0) (make-letter-count "p" 0)
       (make-letter-count "q" 0) (make-letter-count "r" 0)
       (make-letter-count "s" 0) (make-letter-count "t" 0)
       (make-letter-count "u" 0) (make-letter-count "v" 0)
       (make-letter-count "w" 0) (make-letter-count "x" 0)
       (make-letter-count "y" 0) (make-letter-count "z" 0)))

;(define (count-by-letter los) '()) ;stub

(define (count-by-letter lolet dict)
  (cond [(empty? lolet) '()]
        [else
         (cons
          (make-letter-count (first lolet)
                             (starts-with# (first lolet) dict))
          (count-by-letter (rest lolet) dict))]))

;; 197 this exercise includes multiple different designs of the same function

;; how to handle ties?

;; Dictionary -> Letter-Count
;; return the Letter-Count for the most frequently (highest value in count)
(check-expect (most-frequentv1 TEST-SMALL) (make-letter-count "a" 2))
(check-expect (most-frequentv2 TEST-SMALL) (make-letter-count "a" 2))
(check-expect (most-frequentv1 TEST-LIST) (make-letter-count "s" 458))
(check-expect (most-frequentv2 TEST-LIST) (make-letter-count "s" 458))
;(define (most-frequentv1 d) (make-letter-count "a" 0)) ;stub
;(define (most-frequentv2 d) (make-letter-count "a" 0)) ;stub
(define (most-frequentv1 d)
  (local [(define c (count-by-letter LETTERS d))
          (define (insert lc llc)
            (cond [(empty? llc) (list lc)]
                  [else
                   (if (> (letter-count-count lc)
                          (letter-count-count (first llc)))
                       (cons lc llc)
                       (cons (first llc) (insert lc (rest llc))))]))
          (define (sorted>llc llc)
            (cond
              [(empty? llc) '()]
              [else (insert (first llc) (sorted>llc (rest llc)))]))]
    (first (sorted>llc c))))

(define (most-frequentv2 d)
  (local [(define c (count-by-letter LETTERS d))
          (define (process llc) 
            (cond [(empty? (rest llc)) (first llc)]
                  [else  (if (> (letter-count-count (first llc))
                                (letter-count-count (first (rest llc))))
                             (process (cons (first llc)
                                            (rest (rest llc))))
                             (process (rest llc)))]))]
    (process c)))





