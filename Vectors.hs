{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE RankNTypes #-}

import Data.Vector
import Linear.V
import Data.Constraint

import qualified Data.Vector as V
import qualified Linear.V    as LV

foo :: (Show a) => LV.V n a -> String
foo = show . LV.toVector

bar :: V 3 Int
bar = LV.V $ V.fromList [1,2 , 3]

main :: IO ()
main = print $ foo bar

{-
o.hs:16:20:
    Couldn't match kind ‘GHC.TypeLits.Nat’ with ‘*’
    Expected type: V n0 Int
      Actual type: V 3 Int
    In the first argument of ‘foo’, namely ‘bar’
    In the second argument of ‘($)’, namely ‘foo bar’
-}
