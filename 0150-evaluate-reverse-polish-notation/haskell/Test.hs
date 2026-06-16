module Main where

import Solution (evalRPN)
import TestUtil (Case(..), assertEqual, runCases)

data Expr
  = Lit Int
  | Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr
  | Div Expr Expr

main :: IO ()
main = runCases "0150-evaluate-reverse-polish-notation" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ Case "example 1" (assertEqual 9 (evalRPN ["2", "1", "+", "3", "*"]))
  , Case "example 2" (assertEqual 36 (evalRPN ["6", "4", "13", "5", "/", "+", "*"]))
  , Case "example 3" (assertEqual 22 (evalRPN ["10", "6", "9", "3", "+", "-11", "*", "/", "*", "17", "+", "5", "+"]))
  , Case "division positive" (assertEqual 2 (evalRPN ["7", "3", "/"]))
  , Case "division negative numerator" (assertEqual (-2) (evalRPN ["-7", "3", "/"]))
  , Case "division negative denominator" (assertEqual (-2) (evalRPN ["7", "-3", "/"]))
  , Case "division both negative" (assertEqual 2 (evalRPN ["-7", "-3", "/"]))
  ]

generatedCases :: [Case]
generatedCases =
  [ Case ("generated expr " ++ show n) (assertEqual (evalExpr expr) (evalRPN (toRpn expr)))
  | n <- [0 .. 40]
  , let expr = generatedExpr n
  ]

generatedExpr :: Int -> Expr
generatedExpr n =
  case n `mod` 5 of
    0 -> Add (Lit (n - 12)) (Mul (Lit 3) (Lit (n `mod` 7 + 1)))
    1 -> Sub (Mul (Lit (n + 2)) (Lit 2)) (Lit (n `mod` 9))
    2 -> Div (Mul (Lit (n + 9)) (Lit (den n))) (Lit (den n))
    3 -> Add (Div (Lit (negate (n + 8))) (Lit 3)) (Lit 4)
    _ -> Mul (Sub (Lit n) (Lit 5)) (Add (Lit 1) (Lit (n `mod` 4)))
  where
    den k = k `mod` 5 + 1

evalExpr :: Expr -> Int
evalExpr (Lit x) = x
evalExpr (Add l r) = evalExpr l + evalExpr r
evalExpr (Sub l r) = evalExpr l - evalExpr r
evalExpr (Mul l r) = evalExpr l * evalExpr r
evalExpr (Div l r) = evalExpr l `quot` evalExpr r

toRpn :: Expr -> [String]
toRpn (Lit x) = [show x]
toRpn (Add l r) = toRpn l ++ toRpn r ++ ["+"]
toRpn (Sub l r) = toRpn l ++ toRpn r ++ ["-"]
toRpn (Mul l r) = toRpn l ++ toRpn r ++ ["*"]
toRpn (Div l r) = toRpn l ++ toRpn r ++ ["/"]

