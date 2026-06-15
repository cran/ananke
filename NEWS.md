# ananke 0.3.0
## New classes and methods
* Add `radialplot()` to produce a radial plot.

## Bugfixes & changes
* Fix `as.data.frame()` method for `CalibratedAges`.
* Fix color mapping in `ridgelines()`.

# ananke 0.2.0
## New classes and methods
* Add `ridgelines()` to produce a ridgeline plot of calibrated radiocarbon ages.
* Add `summary()` to produce summaries of calibrated radiocarbon ages.

## Enhancements
* The `as.data.frame()` method for `CalibratedAges` now returns a tidy `data.frame`.

## Breaking changes
* Rename `F14C_to_BP14C()` to `f14c_c14()` and `BP14C_to_F14C()` to `c14_f14c()`.

# ananke 0.1.0

* First CRAN release.

# ananke 0.0.1

* First pre-release.
