-- example code for list comprehension
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
suits = [ "club", "diamond", "heart", "spade" ]
rank  = [ "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2", "A" ]
deck  = [ (s, r) | s <- suits, r <- rank ]

{- 
     comment block
-}

-- sum of squares
sumS :: Integer -> Integer -> Integer
sumS n m 
    = sqN + sqM 
    where 
    sqN = n * n 
    sqM = m * m 

-- quicksort
qsort :: [Integer] -> [Integer]
qsort [] = []
qsort (x:xs)
     = [ y | y <- xs, y <= x ] ++ [x] ++ qsort [ y | y <- xs, y > x ]

-- quicksort strings
qsort2 :: Ord a => [a] -> [a] 
qsort2 [] = []
qsort2 [x] = [x]
qsort2 (x:y) = qsort2 smaller ++ [x] ++ qsort2 bigger
     where split sm bg [] = (sm, bg)
           split sm bg (a:b) | x < a = split sm (a:bg) b
                             | otherwise = split (a:sm) bg b
           (smaller, bigger) = split [] [] y

-- function composition
twice f = (f.f)

success :: Integer -> Integer
success n = n + 1

addNum :: Integer -> (Integer -> Integer)
addNum n = addN
      where addN m = n + m

{-
     foo n = \m -> n + m
     h = foo 10101
     h 99 -- 10200
-}

-- these types are not strings!!
data Temp      = Cold | Hot
data Season    = Spring | Summer | Autumn | Winter

weather :: Season -> Temp
weather Summer = Hot
weather _ = Cold

type Name = String
type Age = Integer
data Person = Person Name Age
     deriving Show

-- (v, vs); v is the head (first term), vs is the tail (everything else)
-- 



formatPrice :: String -> Double -> String
formatPrice currency price = currency ++ show price

formatEuro = formatPrice "e"

removeDupes :: [Integer] -> [Integer] -> [Integer]
removeDupes [] _ = []
removeDupes (x:xs) a
    | x `notElem` a     = x : removeDupes xs (a ++ [x])
    | x `elem` a        = removeDupes xs a
