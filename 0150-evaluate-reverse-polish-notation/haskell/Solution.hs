module Solution (evalRPN) where

import qualified Text.Read as T
import Data.List (foldl')

-- Problem 150. Evaluate Reverse Polish Notation
evalRPN :: [String] -> Int
evalRPN tokens = case foldl' step [] tokens of
                    []   -> 0
                    t:_  -> t
    where step = \stack s -> case (T.readMaybe s) :: Maybe Int of
                                Just n  -> n:stack
                                Nothing -> case stack of
                                            []         -> error "invalid input"
                                            [_]        -> error "invalid input"
                                            s1:s0:rest -> let ops = case s of
                                                                    "+" -> \x y -> x+y
                                                                    "-" -> \x y -> x-y
                                                                    "*" -> \x y -> x*y
                                                                    "/" -> \x y -> x `quot` y
                                                                    _   -> error "invalid input"
                                                          in (ops s0 s1):rest
