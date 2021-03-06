{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NegativeLiterals #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}
-- |
-- Module      : Graphics.Color.Space.RGB.ITU.Rec601
-- Copyright   : (c) Alexey Kuleshevich 2019-2020
-- License     : BSD3
-- Maintainer  : Alexey Kuleshevich <lehins@yandex.ru>
-- Stability   : experimental
-- Portability : non-portable
--
module Graphics.Color.Space.RGB.ITU.Rec601
  ( pattern BT601_525
  , BT601_525
  , pattern BT601_625
  , BT601_625
  , D65
  , primaries525
  , primaries625
  , transfer
  , itransfer
  , module Graphics.Color.Space
  ) where

import Data.Coerce
import Data.Typeable
import Foreign.Storable
import Graphics.Color.Illuminant.ITU.Rec601
import Graphics.Color.Model.Internal
import qualified Graphics.Color.Model.RGB as CM
import Graphics.Color.Space
import Graphics.Color.Space.RGB.ITU.Rec470 (primaries625)
import Graphics.Color.Space.RGB.Luma



------------------------------------
-- ITU-R BT.601 (525) --------------
------------------------------------

-- | [ITU-R BT.601](https://en.wikipedia.org/wiki/Rec._601) (525) color space
data BT601_525 (l :: Linearity)

newtype instance Color (BT601_525 l) e = BT601_525 (Color CM.RGB e)

-- | ITU-R BT.601 (525) color space
deriving instance Eq e => Eq (Color (BT601_525 l) e)
-- | ITU-R BT.601 (525) color space
deriving instance Ord e => Ord (Color (BT601_525 l) e)
-- | ITU-R BT.601 (525) color space
deriving instance Functor (Color (BT601_525 l))
-- | ITU-R BT.601 (525) color space
deriving instance Applicative (Color (BT601_525 l))
-- | ITU-R BT.601 (525) color space
deriving instance Foldable (Color (BT601_525 l))
-- | ITU-R BT.601 (525) color space
deriving instance Traversable (Color (BT601_525 l))
-- | ITU-R BT.601 (525) color space
deriving instance Storable e => Storable (Color (BT601_525 l) e)

-- | ITU-R BT.601 (525) color space
instance  (Typeable l, Elevator e) => Show (Color (BT601_525 l) e) where
  showsPrec _ = showsColorModel

-- | ITU-R BT.601 (525) color space
instance  (Typeable l, Elevator e) => ColorModel (BT601_525 l) e where
  type Components (BT601_525 l) e = (e, e, e)
  toComponents = toComponents . unColorRGB
  {-# INLINE toComponents #-}
  fromComponents = mkColorRGB . fromComponents
  {-# INLINE fromComponents #-}

-- | ITU-R BT.601 (525) linear color space
instance Elevator e => ColorSpace (BT601_525 'Linear) D65 e where
  type BaseModel (BT601_525 'Linear) = CM.RGB
  toBaseSpace = id
  {-# INLINE toBaseSpace #-}
  fromBaseSpace = id
  {-# INLINE fromBaseSpace #-}
  luminance = rgbLinearLuminance . fmap toRealFloat
  {-# INLINE luminance #-}
  toColorXYZ = rgbLinear2xyz . fmap toRealFloat
  {-# INLINE toColorXYZ #-}
  fromColorXYZ = fmap fromRealFloat . xyz2rgbLinear
  {-# INLINE fromColorXYZ #-}


-- | ITU-R BT.601 (525) linear color space
instance Elevator e => ColorSpace (BT601_525 'NonLinear) D65 e where
  type BaseModel (BT601_525 'NonLinear) = CM.RGB
  toBaseSpace = id
  {-# INLINE toBaseSpace #-}
  fromBaseSpace = id
  {-# INLINE fromBaseSpace #-}
  luminance = rgbLuminance . fmap toRealFloat
  {-# INLINE luminance #-}
  toColorXYZ = rgb2xyz . fmap toRealFloat
  {-# INLINE toColorXYZ #-}
  fromColorXYZ = fmap fromRealFloat . xyz2rgb
  {-# INLINE fromColorXYZ #-}

-- | ITU-R BT.601 (525) color space
instance RedGreenBlue BT601_525 D65 where
  gamut = primaries525
  ecctf = BT601_525 . fmap transfer . coerce
  {-# INLINE ecctf #-}
  dcctf = BT601_525 . fmap itransfer . coerce
  {-# INLINE dcctf #-}

------------------------------------
-- ITU-R BT.601 (625) --------------
------------------------------------

-- | [ITU-R BT.601](https://en.wikipedia.org/wiki/Rec._601) (625) color space
data BT601_625 (l :: Linearity)

newtype instance Color (BT601_625 l) e = BT601_625 (Color CM.RGB e)

-- | ITU-R BT.601 (625) color space
deriving instance Eq e => Eq (Color (BT601_625 l) e)
-- | ITU-R BT.601 (625) color space
deriving instance Ord e => Ord (Color (BT601_625 l) e)
-- | ITU-R BT.601 (625) color space
deriving instance Functor (Color (BT601_625 l))
-- | ITU-R BT.601 (625) color space
deriving instance Applicative (Color (BT601_625 l))
-- | ITU-R BT.601 (625) color space
deriving instance Foldable (Color (BT601_625 l))
-- | ITU-R BT.601 (625) color space
deriving instance Traversable (Color (BT601_625 l))
-- | ITU-R BT.601 (625) color space
deriving instance Storable e => Storable (Color (BT601_625 l) e)

-- | ITU-R BT.601 (625) color space
instance (Typeable l, Elevator e) => Show (Color (BT601_625 l) e) where
  showsPrec _ = showsColorModel

-- | ITU-R BT.601 (625) color space
instance (Typeable l, Elevator e) => ColorModel (BT601_625 l) e where
  type Components (BT601_625 l) e = (e, e, e)
  toComponents = toComponents . unColorRGB
  {-# INLINE toComponents #-}
  fromComponents = mkColorRGB . fromComponents
  {-# INLINE fromComponents #-}

-- | ITU-R BT.601 (625) linear color space
instance Elevator e => ColorSpace (BT601_625 'Linear) D65 e where
  type BaseModel (BT601_625 'Linear) = CM.RGB
  toBaseSpace = id
  {-# INLINE toBaseSpace #-}
  fromBaseSpace = id
  {-# INLINE fromBaseSpace #-}
  luminance = rgbLinearLuminance . fmap toRealFloat
  {-# INLINE luminance #-}
  toColorXYZ = rgbLinear2xyz . fmap toRealFloat
  {-# INLINE toColorXYZ #-}
  fromColorXYZ = fmap fromRealFloat . xyz2rgbLinear
  {-# INLINE fromColorXYZ #-}

-- | ITU-R BT.601 (625) color space
instance Elevator e => ColorSpace (BT601_625 'NonLinear) D65 e where
  type BaseModel (BT601_625 'NonLinear) = CM.RGB
  toBaseSpace = id
  {-# INLINE toBaseSpace #-}
  fromBaseSpace = id
  {-# INLINE fromBaseSpace #-}
  luminance = rgbLuminance . fmap toRealFloat
  {-# INLINE luminance #-}
  toColorXYZ = rgb2xyz . fmap toRealFloat
  {-# INLINE toColorXYZ #-}
  fromColorXYZ = fmap fromRealFloat . xyz2rgb
  {-# INLINE fromColorXYZ #-}

-- | ITU-R BT.601 (625) color space
instance RedGreenBlue BT601_625 D65 where
  gamut = primaries625
  ecctf = BT601_625 . fmap transfer . coerce
  {-# INLINE ecctf #-}
  dcctf = BT601_625 . fmap itransfer . coerce
  {-# INLINE dcctf #-}

instance Luma BT601_525 where
  rWeight = 0.299
  gWeight = 0.587
  bWeight = 0.114

instance Luma BT601_625 where
  rWeight = 0.299
  gWeight = 0.587
  bWeight = 0.114


-- | Rec.601 transfer function "gamma". This is a helper function, therefore `ecctf` should be used
-- instead.
--
-- \[
-- \gamma(L) = \begin{cases}
--     4.500 L & L \le 0.018 \\
--     1.099 L^{0.45} - 0.099 & \text{otherwise}
--   \end{cases}
-- \]
--
-- @since 0.1.0
transfer :: (Ord a, Floating a) => a -> a
transfer l
  | l < 0.018 = 4.5 * l
  | otherwise = 1.099 * (l ** 0.45 {- ~ 1 / 2.2 -}) - 0.099
{-# INLINE transfer #-}

-- | Rec.601 inverse transfer function "gamma". This is a helper function, therefore `dcctf` should
-- be used instead.
--
-- \[
-- \gamma^{-1}(E) = \begin{cases}
--     E / 4.5 & E \leq gamma(0.018) \\
--     \left(\tfrac{E + 0.099}{1.099}\right)^{\frac{1}{0.45}} & \text{otherwise}
--   \end{cases}
-- \]
--
-- @since 0.1.0
itransfer :: (Ord a, Floating a) => a -> a
itransfer e
  | e < inv0018 = e / 4.5
  | otherwise = ((e + 0.099) / 1.099) ** (1 / 0.45)
  where
    !inv0018 = transfer 0.018 -- ~ 0.081
{-# INLINE itransfer #-}


-- | Primaries for ITU-R BT.601 (525).
--
-- @since 0.1.0
primaries525 :: RealFloat e => Gamut rgb i e
primaries525 = Gamut (Primary 0.630 0.340)
                     (Primary 0.310 0.595)
                     (Primary 0.155 0.070)

