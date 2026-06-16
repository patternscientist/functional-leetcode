module TestUtil
  ( Case(..)
  , Result(..)
  , assertEqual
  , assertBool
  , runCases
  ) where

import System.Exit (exitFailure, exitSuccess)

data Result = Pass | Fail String
  deriving (Eq, Show)

data Case = Case
  { caseName :: String
  , caseResult :: Result
  }

assertEqual :: (Eq a, Show a) => a -> a -> Result
assertEqual expected actual
  | expected == actual = Pass
  | otherwise =
      Fail $
        "Expected: " ++ show expected ++ "\n" ++
        "Actual:   " ++ show actual

assertBool :: String -> Bool -> Result
assertBool _ True = Pass
assertBool message False = Fail message

runCases :: String -> [Case] -> IO ()
runCases suiteName cases =
  case failures of
    [] -> do
      putStrLn $
        "PASS " ++ suiteName ++ ": " ++
        show (length cases) ++ " / " ++ show (length cases) ++
        " fixed/generated cases passed"
      exitSuccess
    (Case name (Fail message):_) -> do
      putStrLn $
        "FAIL " ++ suiteName ++ ": " ++
        show (length cases - length failures) ++ " / " ++
        show (length cases) ++ " cases passed"
      putStrLn ""
      putStrLn "First counterexample"
      putStrLn name
      putStrLn message
      exitFailure
    _ -> exitFailure
  where
    failures = filter isFailure cases

isFailure :: Case -> Bool
isFailure (Case _ Pass) = False
isFailure (Case _ (Fail _)) = True

