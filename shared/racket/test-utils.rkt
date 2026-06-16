#lang racket

(provide run-cases)

(define (run-cases suite cases)
  (define total (length cases))
  (for ([case cases]
        [idx (in-naturals 1)])
    (define name (first case))
    (define thunk (second case))
    (unless (thunk)
      (printf "FAIL ~a: ~a / ~a cases passed\n" suite (- idx 1) total)
      (printf "\nFirst counterexample\n~a\n" name)
      (exit 1)))
  (printf "PASS ~a: ~a / ~a fixed/generated cases passed\n" suite total total))

