#lang racket

(require "solution.rkt"
         "../../shared/racket/test-utils.rkt")

(define fixed-cases
  (list
   (check "mixed example" '(-2 1 -3 4 -1 2 1 -5 4))
   (check "singleton positive" '(1))
   (check "all positive with dip" '(5 4 -1 7 8))
   (check "singleton negative" '(-1))
   (check "all negative pair" '(-2 -1))
   (check "zero included" '(-3 0 -2))))

(define generated-cases
  (for/list ([n (in-range 1 36)])
    (check (format "generated length ~a" n) (generated-nums n))))

(define (generated-nums n)
  (for/list ([i (in-range n)])
    (- (modulo (+ (* i 11) (* n 5)) 19) 9)))

(define (check name nums)
  (list name (lambda () (= (slow-max-subarray nums) (max-sub-array nums)))))

(define (slow-max-subarray nums)
  (apply max
         (for*/list ([start (in-range (length nums))]
                     [len (in-range 1 (+ (- (length nums) start) 1))])
           (apply + (take (drop nums start) len)))))

(run-cases "0053-maximum-subarray/racket" (append fixed-cases generated-cases))
