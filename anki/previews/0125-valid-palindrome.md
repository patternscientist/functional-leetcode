# 125. Valid Palindrome

## Pattern

Two pointers with on-demand normalization: skip non-alphanumerics and compare lowercase endpoints.

## Invariant

Before each comparison, all characters outside the pointer interval have already matched under the normalization policy.

## Code

isPalindrome s = step 0 (length s - 1) True

step l r ok skips punctuation inward, compares lowercase alphanumeric endpoints, then recurs inward

## Complexity

Time: O(n). Space: O(n) here for the array; the pointer idea itself can be O(1) extra.

## Pitfall(s)

Underscore is not alphanumeric. Digits remain significant. Empty normalized strings are palindromes.
