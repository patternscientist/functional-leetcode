module Solution (Tree(..), invertTree) where

data Tree a = Empty | Node a (Tree a) (Tree a)
  deriving (Eq, Show)

invertTree :: Tree a -> Tree a
invertTree Empty = Empty
invertTree (Node x l r) = Node x (invertTree r) (invertTree l)

