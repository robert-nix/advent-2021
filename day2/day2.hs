{-# LANGUAGE ViewPatterns #-}
import Data.Char
import Data.List

data Coord = Coord Int Int deriving (Show)
(Coord x y) `add` (Coord x' y') = Coord (x+x') (y+y')
encode (Coord x y) = x * y

walk c (stripPrefix "forward" -> Just n) = add c (Coord (read n) 0)
walk c (stripPrefix "down" -> Just n) = add c (Coord 0 (read n))
walk c (stripPrefix "up" -> Just n) = add c (Coord 0 (-(read n)))
walk c string = error ("invalid walk: " ++ string)


main = do
    contents <- getContents
    let c = foldl (walk) (Coord 0 0) (lines contents)
    print (encode c)
