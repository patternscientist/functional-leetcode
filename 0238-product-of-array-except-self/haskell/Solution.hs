module Solution (productExceptSelf) where

-- Problem 238. Product of Array Except Self
productExceptSelf :: [Int] -> [Int]
productExceptSelf = zipWith (*) <$> (init . scanl (*) 1) <*> (drop 1 . scanr (*) 1)
