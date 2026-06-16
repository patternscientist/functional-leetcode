#lang racket

(require "solution.rkt"
         "../../shared/racket/test-utils.rkt")

(define (check name prices)
  (list name (lambda () (= (slow-max-profit prices) (max-profit prices)))))

(define (slow-max-profit prices)
  (apply max
         0
         (for*/list ([buy (in-range (length prices))]
                     [sell (in-range (+ buy 1) (length prices))])
           (- (list-ref prices sell) (list-ref prices buy)))))

(define (generated-prices n)
  (for/list ([i (in-range n)])
    (+ (modulo (+ (* i i) (* 7 i) (* 3 n)) 23) 1)))

(define fixed-cases
  (list
   (check "example profit" '(7 1 5 3 6 4))
   (check "example no profit" '(7 6 4 3 1))
   (check "single day" '(5))
   (check "buy first sell last" '(1 2))
   (check "late low price" '(2 4 1))))

(define generated-cases
  (for/list ([n (in-range 1 31)])
    (check (format "generated length ~a" n) (generated-prices n))))

(run-cases "0121-best-time-to-buy-and-sell-stock/racket"
           (append fixed-cases generated-cases))
