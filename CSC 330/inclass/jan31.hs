-- Is Integer in the list of Integers?
-- Example: elem 20 [3, 9, 15] == False
myElem :: Integer -> [Integer] -> Bool
myElem _ [] = False
myElem val (v:vs)
    | val == v      = True
    | otherwise     = myElem val vs

-- Elements in result are doubled
-- Example: doubleAll [20, -10, 0, 5] == [40, -20, 0, 10]
doubleAll :: [Integer] -> [Integer]
-- my code:
-- doubleAll [] = []
-- doubleAll (v:vs) = [ 2 * v ] ++ doubleAll vs
-- code in teams:
-- doubleAll ns = [ 2 * n | n <- ns ]
-- zastre's example:
multTwo m = m * 2
-- doubleAll ns = map multTwo ns
doubleAll = map (* 2)

-- Elements in result are even
-- Example: selectEven [3, 1, 4, 1, 59, 26, 53, 58] == [4, 26, 58]
selectEven :: [Integer] -> [Integer]
-- teams code:
-- selectEven [] = []
-- selectEven (n:ns)
--     | mod n 2 == 0      = n : selectEven ns
--     | otherwise         = selectEven ns
-- my code:
selectEven ns = [ n | n <- ns, even n ]


-- Elements in result are those from start of list != Integer
-- Example: allBefore 5 [3, 1, 4, 1, 5, 9, 2, 6, 7] == [3, 1, 4, 1]
-- my code:
allBefore :: Integer -> [Integer] -> [Integer]
allBefore _ [] = []
allBefore n (v:vs)
    | n == v        = []
    | otherwise     = v : allBefore n vs
-- example code: 
-- my code == zastre's


-- Compute the weighted sum of two list of numbers
-- Example: weightedSum [10, 20, 30] [0.1, 0.3, 0.6] == 25.0
weightedSum :: [Double] -> [Double] -> Double
-- my code:
-- weightedSum [] [] = 0.0
-- weightedSum (x:xs) (y:ys) = x * y + weightedSum xs ys
-- zastre:s
multTwoAccum (a, b) c = a * b + c

weightedSum xs ys = foldr multTwoAccum 0 (zip xs ys)