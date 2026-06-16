#lang racket

(provide max-profit)

(define/contract (max-profit prices)
  (-> (listof exact-integer?) exact-integer?)
  (for/fold ([bottom (first prices)] [best 0] #:result best)
            ([price (rest prices)])
    (let* ([bottomNext (min bottom price)]
           [bestNext (max best (- price bottomNext))])
      (values bottomNext bestNext))))
