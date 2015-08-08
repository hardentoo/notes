module Azor where

import Data.List

azorAhai :: (a -> a -> [a] -> [a]) -> [a] -> [a]
azorAhai f elements = foldl' xs elements [0..length elements]
  where
    xs elems i   = foldl' (`go` i) elems [0..length elems]
    go elems i j = f (elems !! i) (elems !! j) elems