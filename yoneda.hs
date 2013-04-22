{-# LANGUAGE RankNTypes #-}

module Main where

import Data.Functor.Identity

data Yoneda f a = Yoneda
    { runYoneda :: forall b. Functor f => (a -> b) -> f b
    }

embed :: Functor f => f a -> Yoneda f a
embed a = Yoneda $ \f -> fmap f a

unembed :: Functor f => Yoneda f a -> f a
unembed y = runYoneda y id

main = do
    let y = embed (Identity "Hello")
    print $ runIdentity $ runYoneda y length
