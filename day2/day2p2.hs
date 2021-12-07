{-# LANGUAGE ViewPatterns #-}
import Data.Char
import Data.List

data Pos = Pos Int Int Int deriving (Show)
(Pos x d a) `go` (Pos x' d' a') = Pos (x+x') (d+a*x') (a+a')
encode (Pos x y _) = x * y

walk c (stripPrefix "forward" -> Just n) = c `go` (Pos (read n) 0 0)
walk c (stripPrefix "down" -> Just n) = c `go` (Pos 0 0 (read n))
walk c (stripPrefix "up" -> Just n) = c `go` (Pos 0 0 (-(read n)))
walk c string = error ("invalid walk: " ++ string)


main = do
    contents <- getContents
    let c = foldl (walk) (Pos 0 0 0) (lines contents)
    print (encode c)
