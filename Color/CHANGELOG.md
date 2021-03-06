# Changelog for Color

## 0.2.0

* Add `Linearity` kind to `RedGreenBlue` color spaces.
* Add `Default` instance for `Pixel`
* Addition of universal division `(//)` to `Elevator`
* Addition of CIE1931 RGB color space.
* Fix show instance for floating point colors: adjust formatting in Elevator for `Float` and `Double`
* Add record accessor functions: `chromaticityCIExyY`, `whitePointChromaticity`
* Fix show instance for `Gamut`
* Remove deprecated: `CIECAM02` and `ciecam02Adaptation`

## 0.1.4

* Export `pixelColor`
* Add luma related patterns: `PixelY'`, `PixelY'A`, `Y'` and `Y'A`. Also `rgbPixelLuma`

## 0.1.3.1

* Fix introduced in `0.1.2` for `Alpha cs` was incomplete and is fixed in this version
  without breakage.

## 0.1.3 (deprecated)

* Addition of `CMCCAT2000`.
* Rename `CIECAM02` to `CIECAT02` with a fallback synonym for backwards compatibility
* Fix `ColorSpace` instance for `Alpha cs`
* Add `ColorSpace` instances for `YCbCr cs` color spaces that have `Luma` instance:
  `BT709`, `BT601_525` and `BT601_625`

## 0.1.2

* Fix `YCbCr` conversion to derived RGB color spaces
* Fix conversion of `toWord64 (1 :: Double)` and `toWord632 (1 :: Float)`.
* Addition of `xyzColorMatchingFunctions` and `spectralPowerDistributions`

## 0.1.1

* Addition of `Graphics.Color.Illuminant.Wikipedia` module
* Addition of `convertColor` and `convertColorFloat` functions

## 0.1.0

Initial alpha release
