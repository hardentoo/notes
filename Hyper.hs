module Hyper where

import Control.Arrow
import Control.Applicative
import Control.Category
import Control.Monad
import Data.Profunctor
import Prelude hiding (id, (.))

newtype Hyper a b = H { invoke :: Hyper b a -> b }

(#) :: Hyper b c -> Hyper a b -> Hyper a c
f # g = H (\k -> invoke f (g # k))

self :: Hyper a a
self = lift id

lift :: (a -> b) -> Hyper a b
lift f = f << lift f

(<<) :: (a -> b) -> Hyper a b -> Hyper a b
f << q = H (\k -> f (invoke k q))

base :: a -> Hyper b a
base = H . const

run :: Hyper a a -> a
run f = invoke f self

instance Category Hyper where
    id  = self
    (.) = (#)

instance Arrow Hyper where
    arr = lift

instance Profunctor Hyper where
    lmap f (H k) = H (k . rmap f)
    rmap f (H k) = H (f . k . lmap f)

instance Functor (Hyper a) where
    fmap = rmap

-- instance Monad (Hyper a) where
--     return    = base
--     H k >>= f = H $ \h -> invoke (f (k _)) h

-- instance Applicative (Hyper a) where
--     pure  = return
--     (<*>) = ap

fold :: [a] -> (a -> b -> c) -> c -> Hyper b c
fold [] _ n     = base n
fold (x:xs) c n = c x << fold xs c n

foldr' :: (b -> a -> a) -> a -> [b] -> a
foldr' c n xs = run (fold xs c n)

main :: IO ()
main = do
    let x = fold ([1..10] :: [Int]) (+) 0
    print (run (lmap (+100) x))
    print (run (rmap (+100) x))