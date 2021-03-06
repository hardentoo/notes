{-# OPTIONS_GHC -fno-warn-orphans #-}

module Freet where

import Control.Applicative
import Data.Foldable
import Data.Traversable

data ListT m a = Nil | Cons a (m (ListT m a))

foldListT :: Monad m => (a -> m ()) -> ListT m a -> m ()
foldListT _ Nil = return ()
foldListT f (Cons x m) = do
    f x
    xs <- m
    foldListT f xs

data FreeT f m a = Pure a | Free (m (f (FreeT f m a)))

instance Foldable ((,) e) where
    foldMap f (_,a) = f a

instance Traversable ((,) e) where
    traverse f (e,a) = (,) <$> pure e <*> f a

foldFreeT :: (Traversable f, Applicative m, Monad m)
           => (f (FreeT f m a) -> m a) -> FreeT f m a -> m a
foldFreeT _ (Pure a) = return a
foldFreeT f (Free m) = do
    val <- m
    x <- f val
    _ <- traverse (foldFreeT f) val
    return x

toFreeT :: Monad m => ListT m a -> m (FreeT ((,) a) m ())
toFreeT Nil = return $ Pure ()
toFreeT (Cons x m) = do
    val <- m
    val' <- toFreeT val
    return $ Free (return (x, val'))

fromFreeT :: Monad m => FreeT ((,) a) m () -> m (ListT m a)
fromFreeT (Pure ()) = return Nil
fromFreeT (Free m) = do
    (x, xs) <- m
    xs' <- fromFreeT xs
    return $ Cons x (return xs')

main :: IO ()
main = do
    foldListT print listTdata
    foldFreeT (print . fst) freeTdata

    listTdata' <- fromFreeT freeTdata
    foldListT print listTdata'

    freeTdata' <- toFreeT listTdata
    foldFreeT (print . fst) freeTdata'
  where
    listTdata =
        Cons (10 :: Int)
             (return (Cons 20
                           (return (Cons 30
                                         (return Nil)))))
    freeTdata =
        Free (return (10 :: Int,
                      Free (return (20,
                                    Free (return (30,
                                                  Pure ()))))))
