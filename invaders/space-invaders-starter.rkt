;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname space-invaders-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100)

(define BACKGROUND (place-image
                    (rectangle (* 2 WIDTH) 20 "solid" "brown")
                    0
                    (+ HEIGHT 10)
                    (empty-scene WIDTH (+ HEIGHT 20))))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))



;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit I1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit I1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit I1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))


;; =======================
;; Functions:
;; WS -> WS
;; start the world with ...
;;
(define (main ws)
  (big-bang ws                 ;WS
    (on-tick tock)     ;WS->WS
    (to-draw render-game)   ;WS->Image
    (stop-when ...)    ;WS->Boolean
    ; (on-mouse ...)     ;WS Integer Integer MouseEvent -> WS
    (on-key ...)))     ;WS KeyEvent->WS

;; Game -> Game
;; produce the next ...
;; !!!
(define (tock ws) ...)

;; Game -> Image
;; render game
(check-expect
 (render-game (make-game empty empty T0))
 (render-tank T0 BACKGROUND))
(check-expect
 (render-game G3)
 (render-loinvader (list I1 I2)
                   (render-lom (list M1 M2)
                               (render-tank T1
                                            BACKGROUND))))


(define (render-game s)
  (render-loinvader
   (game-invaders s)
   (render-lom
    (game-missiles s)
    (render-tank (game-tank s) BACKGROUND))))

;; List-of-invaders Image -> Image
;; render the list of UFOs
;; !!!
(check-expect (render-loinvader '() BACKGROUND) BACKGROUND)
(check-expect
 (render-loinvader (list (make-invader 100 100 10)) BACKGROUND)
 (place-image INVADER 100 100 BACKGROUND))
(check-expect
 (render-loinvader (list I1 I2 I3) BACKGROUND)
 (place-images
  (list INVADER INVADER INVADER)
  (list (make-posn (invader-x I1) (invader-y I1))
        (make-posn (invader-x I2) (invader-y I2))
        (make-posn (invader-x I3) (invader-y I3))) BACKGROUND))
;(define (render-loinvader loi im) im) ;stub

(define (render-loinvader loi im)
  (cond [(empty? loi) im]
        [else
         (place-image INVADER
                      (invader-x (first loi))
                      (invader-y (first loi))
                      (render-loinvader (rest loi) BACKGROUND))]))

;; List-of-missiles Image -> Image
;; render the list of Missiles
(check-expect (render-lom '() BACKGROUND) BACKGROUND)
(check-expect (render-lom (list (make-missile 100 100)) BACKGROUND)
              (place-image MISSILE 100 100 BACKGROUND))
(check-expect (render-lom (list (make-missile 100 100)
                                (make-missile 120 100)
                                (make-missile 50 50))
                          BACKGROUND)
              (place-images (make-list 3 MISSILE)
                            (list (make-posn 100 100)
                                  (make-posn 120 100)
                                  (make-posn 50 50))
                            BACKGROUND))
;(define (render-lom lom im) im) ;stub

(define (render-lom lom im)
  (cond [(empty? lom) im]
        [else
         (place-images
          (make-list (length lom) MISSILE)
          (map (lambda (m) (make-posn (missile-x m) (missile-y m))) lom)
          im)]))


;; Tank Image -> Image 
;; adds t to the given image im
(check-expect (render-tank T0 BACKGROUND)
              (place-image TANK (tank-x T0)  (- HEIGHT  TANK-HEIGHT/2) BACKGROUND))
(check-expect (render-tank T1 BACKGROUND)
              (place-image TANK (tank-x T1)  (- HEIGHT  TANK-HEIGHT/2) BACKGROUND))
;(define (render-tank t im) im) ;stub

(define (render-tank t im)
  (place-image TANK (tank-x t) (- HEIGHT  TANK-HEIGHT/2) im))




;; Game Key -> Game
;; handle player input
(define (handle-key ws ke)
  (cond [(key=? ke " ") (... ws)]
        [else (... ws)]))
