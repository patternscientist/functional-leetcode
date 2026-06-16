module Solution (Tree(..), isBalanced) where

data Tree a = Empty | Node a (Tree a) (Tree a)
    deriving (Eq,Show)
-- Problem 110. Balanced Binary Tree
heightOrFail :: Tree a -> Maybe Int
heightOrFail Empty = Nothing
heightOrFail (Node _ Empty Empty) = Just 0
heightOrFail (Node _ l r) = do
    lh <- heightOrFail l
    rh <- heightOrFail r
    if (abs (lh-rh) > 1)
    then (Nothing::Maybe Int)
    else return $ 1+(max lh rh)

isBalanced :: Tree Int -> Bool
isBalanced t = case heightOrFail t of
    Nothing -> False
    Just _  -> True
