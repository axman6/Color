{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
module Graphics.Color.Space.RGB.ITU.Rec709Spec (spec) where

import Graphics.Color.Space.Common
import Graphics.Color.Space.RGB.ITU.Rec709

instance (Elevator e, Random e) => Arbitrary (Color (BT709 l) e) where
  arbitrary = ColorRGB <$> arbitraryElevator <*> arbitraryElevator <*> arbitraryElevator


spec :: Spec
spec = describe "Rec709" $ do
  colorModelSpec @(BT709 'NonLinear) @Word "BT709"
  -- Roundrtrip is not always very accurate, eg: 8.115324539550295e-2 /= 8.140132075907752e-2
  colorSpaceLenientSpec @(BT709 'NonLinear) @Float 5e-4
  colorSpaceLenientSpec @(BT709 'Linear) @Double 5e-4
