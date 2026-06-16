module Solution (isValid) where

isValid :: String -> Bool
isValid = finish . foldl step ([], True)
  where
    finish (stack, valid) = valid && null stack

    step (stack, valid) ch
      | not valid = (stack, valid)
      | isOpen ch = (ch : stack, valid)
      | otherwise =
          case stack of
            [] -> (stack, False)
            open:rest -> (rest, matches open ch)

    isOpen ch = ch == '(' || ch == '[' || ch == '{'
    matches '(' ')' = True
    matches '[' ']' = True
    matches '{' '}' = True
    matches _ _ = False

