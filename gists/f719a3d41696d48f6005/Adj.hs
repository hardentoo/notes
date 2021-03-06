module Adj where

import Control.Arrow
import Data.Monoid

type family MonoidElement (m :: *)

type instance MonoidElement [a] = a

type family Forget (m :: *) :: * where
    Forget (Monoid m => m) = MonoidElement m

freeNOT :: a -> (forall m. Monoid m => m)
freeNOT x = undefined -- [x]

-- free :: a -> (exists m. Monoid m => m)
free :: a -> [a]
free x = [x]

forget :: Monoid m => m -> MonoidElement m
forget = undefined

forget' :: (forall m. Monoid m => m) -> a
forget' = undefined

right :: ArrowChoice a => a b c -> a (Either d b) (Either d c)
right f = arr mirror >>> left f >>> arr mirror
  where
    mirror :: Either x y -> Either y x
    mirror (Left x) = Right x
    mirror (Right y) = Left y
