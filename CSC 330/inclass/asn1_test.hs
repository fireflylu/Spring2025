data Thing = Shoe
           | Ship
           | SealingWax
           | Cabbage
           | King
  deriving Show

shoe :: Thing
shoe = Shoe

-- /show
data FailableDouble = Failure 
                    | OK Double
  deriving Show
  
-- show
a = Failure
b = OK 3.4

main = print (a,b)


data Stree a = Tip | Node (Stree a) a (Stree a)
    deriving Show

etree = Node (Node (Node Tip "hi" Tip) "hi" (Node Tip "4" Tip)) "5" (Node Tip "7" Tip)

