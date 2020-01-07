{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE ViewPatterns #-}
-- |
-- Module      : Graphics.Pixel
-- Copyright   : (c) Alexey Kuleshevich 2018-2019
-- License     : BSD3
-- Maintainer  : Alexey Kuleshevich <lehins@yandex.ru>
-- Stability   : experimental
-- Portability : non-portable
--
module Graphics.Pixel
  ( Pixel(..)
  , convertPixel
  , toPixelY
  , toPixel8
  , toPixel16
  , toPixel32
  , toPixel64
  , toPixelF
  , toPixelD
  , liftPixel
  , toPixelBaseModel
  , fromPixelBaseModel
  , toPixelBaseSpace
  , fromPixelBaseSpace
  -- * sRGB color space
  , SRGB
  , D65
  , pattern PixelSRGB
  , pattern PixelSRGBA
  -- * Any RGB color space
  , AdobeRGB
  , pattern PixelRGB
  , pattern PixelRGBA
  , pattern PixelHSI
  , pattern PixelHSIA
  , pattern PixelYCbCr
  , pattern PixelYCbCrA
  , module Graphics.Color.Model
  , module Graphics.Color.Space
  ) where
import Data.Coerce
import Graphics.Color.Adaptation.VonKries
import Graphics.Color.Model
import Graphics.Color.Model.Alpha
import qualified Graphics.Color.Model.RGB as CM
import Graphics.Color.Space
import Graphics.Color.Space.RGB.SRGB
import Graphics.Color.Space.RGB.AdobeRGB
import Graphics.Color.Space.RGB.Alternative
import Foreign.Storable

-- | Imaging is one of the most common places for a color to be used in.  where each pixel
-- has a specific color. This is a zero cost newtype wrapper around a `Color`.
--
-- @since 0.1.0
newtype Pixel cs e = Pixel
  { pixelColor :: Color cs e
  }

deriving instance Eq (Color cs e) => Eq (Pixel cs e)
deriving instance Ord (Color cs e) => Ord (Pixel cs e)
deriving instance Functor (Color cs) => Functor (Pixel cs)
deriving instance Applicative (Color cs) => Applicative (Pixel cs)
deriving instance Foldable (Color cs) => Foldable (Pixel cs)
deriving instance Traversable (Color cs) => Traversable (Pixel cs)
deriving instance Storable (Color cs e) => Storable (Pixel cs e)
instance Show (Color cs e) => Show (Pixel cs e) where
  show = show . pixelColor


-- | Convert a pixel from one color space to any other.
--
-- @since 0.1.0
convertPixel ::
     forall cs i e cs' i' e' . (ColorSpace cs' i' e', ColorSpace cs i e)
  => Pixel cs' e'
  -> Pixel cs e
convertPixel = Pixel . convert . pixelColor
{-# INLINE convertPixel #-}


-- | Constructor for a pixel in @sRGB@ color space
pattern PixelSRGB :: e -> e -> e -> Pixel SRGB e
pattern PixelSRGB r g b = Pixel (SRGB (CM.ColorRGB r g b))
{-# COMPLETE PixelSRGB #-}

-- | Constructor for a pixel in @sRGB@ color space with Alpha channel
pattern PixelSRGBA :: e -> e -> e -> e -> Pixel (Alpha SRGB) e
pattern PixelSRGBA r g b a = Pixel (Alpha (SRGB (CM.ColorRGB r g b)) a)
{-# COMPLETE PixelSRGBA #-}


-- | Constructor for a pixel in RGB color space.
pattern PixelRGB :: RedGreenBlue cs (i :: k) => e -> e -> e -> Pixel cs e
pattern PixelRGB r g b <- (coerce . unColorRGB . coerce -> V3 r g b) where
        PixelRGB r g b = coerce (mkColorRGB (coerce (V3 r g b)))
{-# COMPLETE PixelRGB #-}

-- -- | Constructor for a pixel in RGB color space.
-- pattern PixelRGB :: RedGreenBlue cs i => e -> e -> e -> Pixel cs e
-- pattern PixelRGB r g b <- (unColorRGB . pixelColor -> CM.ColorRGB r g b) where
--         PixelRGB r g b = Pixel (mkColorRGB (CM.ColorRGB r g b))
-- {-# COMPLETE PixelRGB #-}

-- | Constructor for a pixel in RGB color space with Alpha channel
pattern PixelRGBA :: RedGreenBlue cs i => e -> e -> e -> e -> Pixel (Alpha cs) e
pattern PixelRGBA r g b a <- (pixelColor -> Alpha (unColorRGB -> CM.ColorRGB r g b) a) where
        PixelRGBA r g b a = Pixel (Alpha (mkColorRGB (CM.ColorRGB r g b)) a)
{-# COMPLETE PixelRGBA #-}

-- | Constructor for @HSI@.
pattern PixelHSI :: e -> e -> e -> Pixel (HSI cs) e
pattern PixelHSI h s i = Pixel (ColorHSI h s i)
{-# COMPLETE PixelHSI #-}


-- | Constructor for @HSI@ with alpha channel.
pattern PixelHSIA :: e -> e -> e -> e -> Pixel (Alpha (HSI cs)) e
pattern PixelHSIA h s i a = Pixel (ColorHSIA h s i a)
{-# COMPLETE PixelHSIA #-}


-- | Constructor for @YCbCr@.
pattern PixelYCbCr :: e -> e -> e -> Pixel (YCbCr cs) e
pattern PixelYCbCr y cb cr = Pixel (ColorYCbCr y cb cr)
{-# COMPLETE PixelYCbCr #-}


-- | Constructor for @YCbCr@ with alpha channel.
pattern PixelYCbCrA :: e -> e -> e -> e -> Pixel (Alpha (YCbCr cs)) e
pattern PixelYCbCrA y cb cr a = Pixel (ColorYCbCrA y cb cr a)
{-# COMPLETE PixelYCbCrA #-}

toPixelY :: ColorSpace cs i e => Pixel cs e -> Pixel (Y i) e
toPixelY = Pixel . fmap (fromRealFloat @_ @Double) . toColorY . pixelColor
{-# INLINE toPixelY #-}

liftPixel :: (Color cs e -> Color cs' e') -> Pixel cs e -> Pixel cs' e'
liftPixel f = coerce . f . coerce
{-# INLINE liftPixel #-}

-- Elevation

-- | Convert all channels of a pixel to 8bits each, while doing appropriate scaling. See
-- `Elevator`.
--
-- @since 0.1.0
toPixel8 :: ColorModel cs e => Pixel cs e -> Pixel cs Word8
toPixel8 = liftPixel (fmap toWord8)
{-# INLINE toPixel8 #-}

-- | Convert all channels of a pixel to 16bits each, while appropriate scaling. See
-- `Elevator`.
--
-- @since 0.1.0
toPixel16 :: ColorModel cs e => Pixel cs e -> Pixel cs Word16
toPixel16 = liftPixel (fmap toWord16)
{-# INLINE toPixel16 #-}


-- | Convert all channels of a pixel to 32bits each, while doing appropriate scaling. See
-- `Elevator`.
--
-- @since 0.1.0
toPixel32 :: ColorModel cs e => Pixel cs e -> Pixel cs Word32
toPixel32 = liftPixel (fmap toWord32)
{-# INLINE toPixel32 #-}


-- | Convert all channels of a pixel to 64bits each, while doing appropriate scaling. See
-- `Elevator`.
--
-- @since 0.1.0
toPixel64 :: ColorModel cs e => Pixel cs e -> Pixel cs Word64
toPixel64 = liftPixel (fmap toWord64)
{-# INLINE toPixel64 #-}


-- | Convert all channels of a pixel to 32bit floating point numers each, while doing
-- appropriate scaling. See `Elevator`.
--
-- @since 0.1.0
toPixelF :: ColorModel cs e => Pixel cs e -> Pixel cs Float
toPixelF = liftPixel (fmap toFloat)
{-# INLINE toPixelF #-}

-- | Convert all channels of a pixel to 64bit floating point numers each, while doing
-- appropriate scaling. See `Elevator`.
--
-- @since 0.1.0
toPixelD :: ColorModel cs e => Pixel cs e -> Pixel cs Double
toPixelD = liftPixel (fmap toDouble)
{-# INLINE toPixelD #-}



-- Color Space conversions

-- | Drop all color space information and only keep the values encoded in the fitting
-- color model, which the color space is backed by.
--
-- @since 0.1.0
toPixelBaseModel :: ColorSpace cs i e => Pixel cs e -> Pixel (BaseModel cs) e
toPixelBaseModel = liftPixel toBaseModel
{-# INLINE toPixelBaseModel #-}

-- | Promote a pixel without color space information to a color space that is backed by
-- the fitting color model
--
-- @since 0.1.0
fromPixelBaseModel :: ColorSpace cs i e => Pixel (BaseModel cs) e -> Pixel cs e
fromPixelBaseModel = liftPixel fromBaseModel
{-# INLINE fromPixelBaseModel #-}

-- | Convert pixel in an alternative representation of color space, to its base color
-- space. Example from CMYK to SRGB
--
-- @since 0.1.0
toPixelBaseSpace ::
     (ColorSpace cs i e, bcs ~ BaseSpace cs, ColorSpace bcs i e) => Pixel cs e -> Pixel bcs e
toPixelBaseSpace = liftPixel toBaseSpace
{-# INLINE toPixelBaseSpace #-}

-- | Covert a color space of a pixel into it's alternative representation. Example AdobeRGB to HSI.
--
-- @since 0.1.0
fromPixelBaseSpace ::
     (ColorSpace cs i e, bcs ~ BaseSpace cs, ColorSpace bcs i e) => Pixel bcs e -> Pixel cs e
fromPixelBaseSpace = liftPixel fromBaseSpace
{-# INLINE fromPixelBaseSpace #-}


-- toPixelY :: (Elevator a, RealFloat a, ColorSpace cs i e) => Pixel cs e -> Pixel Y a
-- toPixelY = Pixel . toColorY . pixelColor

-- -- | Constructor for a pixel in @sRGB@ color space with 8-bits per channel
-- pattern PixelRGB8 :: Word8 -> Word8 -> Word8 -> Pixel SRGB Word8
-- pattern PixelRGB8 r g b = Pixel (SRGB (CM.ColorRGB r g b))
-- {-# COMPLETE PixelRGB8 #-}

-- -- | Constructor for a pixel in @sRGB@ color space with 16-bits per channel
-- pattern PixelRGB16 :: Word16 -> Word16 -> Word16 -> Pixel SRGB Word16
-- pattern PixelRGB16 r g b = Pixel (SRGB (CM.ColorRGB r g b))
-- {-# COMPLETE PixelRGB16 #-}

-- -- | Constructor for a pixel in @sRGB@ color space with 32-bits per channel
-- pattern PixelRGB32 :: Word32 -> Word32 -> Word32 -> Pixel SRGB Word32
-- pattern PixelRGB32 r g b = Pixel (SRGB (CM.ColorRGB r g b))
-- {-# COMPLETE PixelRGB32 #-}

-- -- | Constructor for a pixel in @sRGB@ color space with 64-bits per channel
-- pattern PixelRGB64 :: Word64 -> Word64 -> Word64 -> Pixel SRGB Word64
-- pattern PixelRGB64 r g b = Pixel (SRGB (CM.ColorRGB r g b))
-- {-# COMPLETE PixelRGB64 #-}

-- -- | Constructor for a pixel in @sRGB@ color space with 32-bit floating point value per channel
-- pattern PixelRGBF :: Float -> Float -> Float -> Pixel SRGB Float
-- pattern PixelRGBF r g b = Pixel (SRGB (CM.ColorRGB r g b))
-- {-# COMPLETE PixelRGBF #-}

-- -- | Constructor for a pixel in @sRGB@ color space with 32-bit floating point value per channel
-- pattern PixelRGBD :: Double -> Double -> Double -> Pixel SRGB Double
-- pattern PixelRGBD r g b = Pixel (SRGB (CM.ColorRGB r g b))
-- {-# COMPLETE PixelRGBD #-}