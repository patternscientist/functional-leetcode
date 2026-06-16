#lang racket

(require "solution.rkt"
         "../../shared/racket/test-utils.rkt")

(define (check name nums)
  (list name
        (lambda ()
          (equal? (slow-product-except-self nums)
                  (product-except-self nums)))))

(define (slow-product-except-self nums)
  (for/list ([i (in-range (length nums))])
    (apply *
           (for/list ([x (in-list nums)]
                      [j (in-naturals)]
                      #:unless (= i j))
             x))))

(define (generated-nums n)
  (for/list ([i (in-range n)])
    (- (modulo (+ (* i 7) n) 5) 2)))

(define fixed-cases
  (list
   (check "example positive" '(1 2 3 4))
   (check "example with zero" '(-1 1 0 -3 3))
   (check "singleton" '(5))
   (check "two zeros" '(0 0))
   (check "one middle zero" '(2 3 0 4))))

(define generated-cases
  (for/list ([n (in-range 1 31)])
    (check (format "generated length ~a" n) (generated-nums n))))

(run-cases "0238-product-of-array-except-self/racket"
           (append fixed-cases generated-cases))
