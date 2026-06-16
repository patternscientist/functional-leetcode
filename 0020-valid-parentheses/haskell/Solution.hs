module Solution (isValid) where

import qualified Data.Map as M
import Data.List (foldl')

-- Problem 050. Valid Parentheses
parenMap :: M.Map String String
parenMap = M.fromList [("}","{"),("]","["),(")","(")]

isValid :: [String] -> Bool
isValid = finish . foldl' step ([],True)
    where finish = \(ss,valid) -> valid && null ss
          step   = \(ss,valid) s -> if not valid
                                    then (ss,valid)
                                    else if M.notMember s parenMap
                                        then (s:ss,valid)
                                        else case ss of
                                                    [] -> (ss,not valid)
                                                    s':rest -> if s' == parenMap M.! s
                                                            then (rest,valid)
                                                            else (rest,not valid)
