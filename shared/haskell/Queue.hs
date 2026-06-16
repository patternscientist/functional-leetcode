module Queue
  ( Queue
  , empty
  , singleton
  , enqueue
  , dequeue
  , null
  , size
  ) where

import Prelude hiding (null)

data Queue a = Queue [a] [a]
  deriving (Eq, Show)

empty :: Queue a
empty = Queue [] []

singleton :: a -> Queue a
singleton x = Queue [x] []

enqueue :: Queue a -> a -> Queue a
enqueue (Queue front back) x = Queue front (x : back)

dequeue :: Queue a -> Maybe (a, Queue a)
dequeue (Queue [] []) = Nothing
dequeue (Queue [] back) = dequeue (Queue (reverse back) [])
dequeue (Queue (x:xs) back) = Just (x, Queue xs back)

null :: Queue a -> Bool
null (Queue [] []) = True
null _ = False

size :: Queue a -> Int
size (Queue front back) = length front + length back

