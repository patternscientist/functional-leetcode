#lang racket

(provide product-except-self)

(define/contract (product-except-self nums)
  (-> (cons/c exact-integer? (listof exact-integer?)) (listof exact-integer?))
  (define reversed-prefixes
    (for/fold ([acc '(1)]
               [prefix-prod (first nums)]
               #:result acc)
              ([num (rest nums)])
      (values (cons prefix-prod acc)
              (* num prefix-prod))))
  (define smun (reverse nums))
  (define suffixes
    (for/fold ([acc '(1)]
               [suffix-prod (first smun)]
               #:result acc)
              ([mun (rest smun)])
      (values (cons suffix-prod acc)
              (* mun suffix-prod))))
  (for/list ([prefix-prod (reverse reversed-prefixes)]
             [suffix-prod suffixes])
    (* prefix-prod suffix-prod)))
