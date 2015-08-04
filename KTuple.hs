{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE GADTs #-}

module KTuple where

import System.IO

type family Fst (xs :: (a, b)) :: a where
  Fst '(x, y) = x

type family Snd (xs :: (a, b)) :: a where
  Snd '(x, y) = y

type T = '(Int, String)

-- data Foo a r = Pure a (Fst r) | Foo r

-- newtype Fix f = Fix { unFix :: f '(Fix f, Fix f) }

-- type Foo' a b = Fix (Foo a)

-- foo :: () -> Snd T
-- foo _ = "Hello"

main :: IO ()
main = do
    _ (withFile "Hello.txt" ReadMode) $ \h ->
        print "Hi"
