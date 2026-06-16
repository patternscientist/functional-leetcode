#lang racket

(provide max-sub-array)

(define/contract (max-sub-array nums)
  (-> (listof exact-integer?) exact-integer?)
  (for/fold ([best (first nums)]
             [end (first nums)]
             #:result best)
            ([num (rest nums)])
    (let* ([endNew (max num (+ num end))]
           [bestNew (max best endNew)])
      (values bestNew endNew))))
