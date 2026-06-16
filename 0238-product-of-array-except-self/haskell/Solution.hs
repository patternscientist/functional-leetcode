module Solution (productExceptSelf) where

productExceptSelf :: [Int] -> [Int]
productExceptSelf =
  zipWith (*) <$> (init . scanl (*) 1) <*> (drop 1 . scanr (*) 1)

