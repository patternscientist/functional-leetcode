#lang racket

(provide max-profit)

(define/contract (max-profit prices)
  (-> (cons/c exact-integer? (listof exact-integer?)) exact-integer?)
  (define first-price (first prices))
  (for/fold ([best 0]
             [bottom first-price]
             #:result best)
            ([price (in-list (rest prices))])
    (define next-bottom (min bottom price))
    (define next-best (max best (- price next-bottom)))
    (values next-best next-bottom)))
