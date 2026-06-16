module Solution (Tree(..), isBalanced) where

data Tree a = Empty | Node a (Tree a) (Tree a)
  deriving (Eq, Show)

-- Empty subtrees are balanced and have height -1. Returning Nothing means an
-- actual balance failure, not absence of a node.
heightOrFail :: Tree a -> Maybe Int
heightOrFail Empty = Just (-1)
heightOrFail (Node _ l r) = do
  lh <- heightOrFail l
  rh <- heightOrFail r
  if abs (lh - rh) > 1
    then Nothing
    else Just (1 + max lh rh)

isBalanced :: Tree Int -> Bool
isBalanced t =
  case heightOrFail t of
    Nothing -> False
    Just _ -> True

