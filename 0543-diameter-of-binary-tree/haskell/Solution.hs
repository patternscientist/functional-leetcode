module Solution (Tree(..), diameterOfBinaryTree) where

data Tree a = Empty | Node a (Tree a) (Tree a)
    deriving (Eq,Show)
-- Problem 543. Diameter of Binary Tree
heightAndBest :: Tree a -> (Int,Int)
heightAndBest Empty = (-1,-1)
heightAndBest (Node _ Empty Empty) = (0,0)
heightAndBest (Node _ l r) = let
                                (lh,lb) = heightAndBest l
                                (rh,rb) = heightAndBest r
                                b       = lh+rh+2
                            in
                                (1+(max lh rh), maximum [lb,rb,b])
diameterOfBinaryTree :: Tree a -> Int
diameterOfBinaryTree = snd . heightAndBest
