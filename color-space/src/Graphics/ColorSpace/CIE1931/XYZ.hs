{-# LANGUAGE PatternSynonyms #-}
-- |
-- Module      : Graphics.ColorSpace.CIE1931.XYZ
-- Copyright   : (c) Alexey Kuleshevich 2019
-- License     : BSD3
-- Maintainer  : Alexey Kuleshevich <lehins@yandex.ru>
-- Stability   : experimental
-- Portability : non-portable
--
module Graphics.ColorSpace.CIE1931.XYZ (
  XYZ, Pixel
  , pattern PixelXYZ
  ) where

import Graphics.ColorSpace.Internal
