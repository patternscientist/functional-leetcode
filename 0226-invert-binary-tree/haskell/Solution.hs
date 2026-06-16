module Solution (Tree(..), invertTree) where

-- Problem 226. Invert Binary Tree
data Tree a = Empty | Node a (Tree a) (Tree a)
    deriving (Eq,Show)
invertTree :: Tree a -> Tree a
invertTree Empty        = Empty
invertTree (Node x l r) = Node x (invertTree r) (invertTree l)
