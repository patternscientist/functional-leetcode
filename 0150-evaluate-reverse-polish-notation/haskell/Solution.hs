module Solution (evalRPN) where

import Data.List (foldl')
import qualified Text.Read as T

evalRPN :: [String] -> Int
evalRPN tokens =
  case foldl' step [] tokens of
    [] -> 0
    t:_ -> t
  where
    step stack s =
      case T.readMaybe s :: Maybe Int of
        Just n -> n : stack
        Nothing ->
          case stack of
            [] -> error "evalRPN: invalid input"
            [_] -> error "evalRPN: invalid input"
            s1:s0:rest -> apply s s0 s1 : rest

    apply "+" x y = x + y
    apply "-" x y = x - y
    apply "*" x y = x * y
    apply "/" x y = x `quot` y
    apply _ _ _ = error "evalRPN: invalid operator"

