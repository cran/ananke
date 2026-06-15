
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ananke

<!-- badges: start -->

<a href="https://ci.codeberg.org/repos/14687" class="pkgdown-devel"><img
src="https://ci.codeberg.org/api/badges/14687/status.svg"
alt="status-badge" /></a>
<a href="https://packages.tesselle.org/ananke/coverage/"
class="pkgdown-devel"><img
src="https://packages.tesselle.org/ananke/coverage/badge.svg"
alt="Code coverage" /></a>
<a href="https://cran.r-project.org/package=ananke"
class="pkgdown-devel"><img
src="https://tinyverse.netlify.app/badge/ananke"
alt="Dependencies" /></a>

<a href="https://tesselle.r-universe.dev/ananke"
class="pkgdown-devel"><img
src="https://tesselle.r-universe.dev/badges/ananke"
alt="r-universe" /></a>
<a href="https://cran.r-project.org/package=ananke"
class="pkgdown-release"><img
src="https://www.r-pkg.org/badges/version/ananke"
alt="CRAN Version" /></a> <a
href="https://cran.r-project.org/web/checks/check_results_ananke.html"
class="pkgdown-release"><img
src="https://badges.cranchecks.info/worst/ananke.svg"
alt="CRAN checks" /></a>
<a href="https://cran.r-project.org/package=ananke"
class="pkgdown-release"><img
src="https://cranlogs.r-pkg.org/badges/ananke"
alt="CRAN Downloads" /></a>

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

[![DOI
Zenodo](https://zenodo.org/badge/DOI/10.5281/zenodo.13236285.svg)](https://doi.org/10.5281/zenodo.13236285)
[![SWH](https://archive.softwareheritage.org/badge/origin/https://codeberg.org/tesselle/ananke/)](https://archive.softwareheritage.org/browse/origin/?origin_url=https://codeberg.org/tesselle/ananke)
<!-- badges: end -->

## Overview

Simple radiocarbon calibration and chronological analysis. This package
allows the calibration of radiocarbon ages and modern carbon fraction
(F<sup>14</sup>C) values using multiple calibration curves. It allows
the calculation of highest density region intervals and credible
intervals. The package also provides tools for visualising results and
estimating statistical summaries.

This package is currently *experimental*. This means that it is
functional, but interfaces and functionalities may change over time,
testing and documentation may be lacking.

------------------------------------------------------------------------

To cite ananke in publications use:

Frerebeau N (2026). *ananke: Quantitative Chronology in Archaeology*.
Université Bordeaux Montaigne, Pessac, France.
<doi:10.5281/zenodo.13236285> <https://doi.org/10.5281/zenodo.13236285>.
R package version 0.3.0, <https://packages.tesselle.org/ananke/>.

This package is a part of the tesselle project
<https://www.tesselle.org>.

## Installation

You can install the released version of **ananke** from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("ananke")
```

And the development version from [Codeberg](https://codeberg.org/) with:

``` r
# install.packages("remotes")
remotes::install_git("https://codeberg.org/tesselle/ananke")
```

## Usage

``` r
# Install extra package, if needed
# install.packages("khroma")

## Load packages
library(ananke)
#> Loading required package: aion
library(khroma)
```

**ananke** uses [**aion**](https://packages.tesselle.org/aion/) for
internal date representation. Look at
`vignette("aion", package = "aion")` before you start.

``` r
## Data from Bosch et al. 2015
data("ksarakil")

## Graphical parameters
par(mar = c(4, 6, 1, 1) + 0.1) # Adjust margins

## Calibrate multiple ages
cal <- c14_calibrate(
  values = ksarakil$date,
  errors = ksarakil$error,
  names = ksarakil$code,
  curves = "marine13",
  reservoir_offsets = 53,
  reservoir_errors = 43,
  from = 50000, to = 0
)

## Plot calibrated ages
ridgelines(
  x = cal, 
  calendar = CE(), 
  col = palette_color_picker("bright")(ksarakil$phase)
)
```

![](man/figures/README-calibration-1.png)<!-- -->

``` r

## 95% intervals
hdr95 <- interval_hdr(cal, level = 0.95)
as.data.frame(hdr95, calendar = CE())
#>        label  start    end    p
#> 1  GrA-53005 -28472 -27538 0.95
#> 2  GrA-54848 -30837 -29740 0.95
#> 3  GrA-53006 -36920 -35614 0.95
#> 4  GrA-57545 -38737 -37401 0.95
#> 5  GrA-54847 -41927 -40650 0.95
#> 6  GrA-57544 -38765 -37560 0.95
#> 7  GrA-57598 -39991 -38970 0.95
#> 8  GrA-57599 -41784 -40694 0.95
#> 9  GrA-53001 -36676 -35245 0.95
#> 10 GrA-54846 -41804 -40640 0.95
#> 11 GrA-57602 -39504 -38384 0.95
#> 12 GrA-57603 -40553 -39761 0.95
#> 13 GrA-57542 -39129 -37916 0.95
#> 14 GrA-53004 -41346 -40383 0.95
#> 15 GrA-57597 -42000 -40766 0.95
#> 16 GrA-53000 -42451 -41111 0.95

## Plot intervals
plot(
  x = hdr95,
  calendar = CE(),
  col = palette_color_picker("bright")(ksarakil$phase),
  lwd = 2
)
```

![](man/figures/README-calibration-2.png)<!-- -->

## Translation

This package provides translations of user-facing communications, like
messages, warnings and errors, and graphical elements (axis labels). The
preferred language is by default taken from the locale. This can be
overridden by setting of the environment variable `LANGUAGE` (you only
need to do this once per session):

``` r
Sys.setenv(LANGUAGE = "<language code>")
```

Languages currently available are English (`en`) and French (`fr`).

## Related Works

- [**Bchron**](https://github.com/andrewcparnell/Bchron) enables quick
  calibration of radiocarbon dates, age-depth modelling, relative sea
  level rate estimation, and non-parametric phase modelling.
- [**rcarbon**](https://github.com/ahb108/rcarbon) includes functions
  not only for basic calibration, uncalibration, and plotting of one or
  more dates, but also a statistical framework for building demographic
  and related longitudinal inferences from aggregate radiocarbon date
  lists.
- [**rintcal**](https://github.com/Maarten14C/rintcal) consists of a
  data compilation of the IntCal radiocarbon calibration curves and
  provides a number of functions to assist with calibrating dates and
  plotting calibration curves.

## Contributing

Please note that the **ananke** project is released with a [Contributor
Code of Conduct](https://www.tesselle.org/conduct.html). By contributing
to this project, you agree to abide by its terms.

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-albarede2012" class="csl-entry">

Albarède, F., A.-M. Desaulty, and J. Blichert-Toft. 2012. “A Geological
Perspective on the Use of Pb Isotopes in Archaeometry.” *Archaeometry*
54 (5): 853–67. <https://doi.org/10.1111/j.1475-4754.2011.00653.x>.

</div>

<div id="ref-albarede1984" class="csl-entry">

Albarède, F., and M. Juteau. 1984. “Unscrambling the Lead Model Ages.”
*Geochimica Et Cosmochimica Acta* 48 (1): 207–12.
<https://doi.org/10.1016/0016-7037(84)90364-8>.

</div>

<div id="ref-allegre2005" class="csl-entry">

Allègre, Claude. 2005. *Géologie isotopique*. Belin sup. Belin.

</div>

<div id="ref-boers2017" class="csl-entry">

Boers, Niklas, Bedartha Goswami, and Michael Ghil. 2017. “A Complete
Representation of Uncertainties in Layer-Counted Paleoclimatic
Archives.” *Climate of the Past* 13 (9): 1169–80.
<https://doi.org/10.5194/cp-13-1169-2017>.

</div>

<div id="ref-bronkramsey2008" class="csl-entry">

Bronk Ramsey, C. 2008. “Radiocarbon Dating: Revolutions in
Understanding.” *Archaeometry* 50 (2): 249–75.
<https://doi.org/10.1111/j.1475-4754.2008.00394.x>.

</div>

<div id="ref-bronkramsey2009" class="csl-entry">

Bronk Ramsey, Christopher. 2009. “Bayesian Analysis of Radiocarbon
Dates.” *Radiocarbon* 51 (1): 337–60.

</div>

<div id="ref-carleton2021" class="csl-entry">

Carleton, W. Christopher. 2021. “Evaluating Bayesian Radiocarbon-Dated
Event Count (REC) Models for the Study of Long-Term Human and
Environmental Processes.” *Journal of Quaternary Science* 36 (1):
110–23. <https://doi.org/10.1002/jqs.3256>.

</div>

<div id="ref-galbraith1988" class="csl-entry">

Galbraith, Rex F. 1988. “Graphical Display of Estimates Having Differing
Standard Errors.” *Technometrics* 30 (3): 271–81.
<https://doi.org/10.1080/00401706.1988.10488400>.

</div>

<div id="ref-galbraith1990" class="csl-entry">

Galbraith, Rex F. 1990. “The Radial Plot: Graphical Assessment of Spread
in Ages.” *International Journal of Radiation Applications and
Instrumentation. Part D. Nuclear Tracks and Radiation Measurements* 17
(3): 207–14. <https://doi.org/10.1016/1359-0189(90)90036-W>.

</div>

<div id="ref-galbraith1994" class="csl-entry">

Galbraith, Rex F. 1994. “Some Applications of Radial Plots.” *Journal of
the American Statistical Association* 89 (428): 1232–42.
<https://doi.org/10.1080/01621459.1994.10476864>.

</div>

<div id="ref-heaton2020" class="csl-entry">

Heaton, Timothy J, Peter Köhler, Martin Butzin, et al. 2020. “Marine20
The Marine Radiocarbon Age Calibration Curve (0–55,000 Cal BP).”
*Radiocarbon* 62 (4): 779–820. <https://doi.org/10.1017/RDC.2020.68>.

</div>

<div id="ref-hogg2020" class="csl-entry">

Hogg, Alan G, Timothy J Heaton, Quan Hua, et al. 2020. “SHCal20 Southern
Hemisphere Calibration, 0–55,000 Years Cal BP.” *Radiocarbon* 62 (4):
759–78. <https://doi.org/10.1017/RDC.2020.59>.

</div>

<div id="ref-hogg2013" class="csl-entry">

Hogg, Alan G, Quan Hua, Paul G Blackwell, et al. 2013. “SHCal13 Southern
Hemisphere Calibration, 0–50,000 Years Cal BP.” *Radiocarbon* 55 (4):
1889–903. <https://doi.org/10.2458/azu_js_rc.55.16783>.

</div>

<div id="ref-hua2004" class="csl-entry">

Hua, Quan, and Mike Barbetti. 2004. “Review of Tropospheric Bomb 14C
Data for Carbon Cycle Modeling and Age Calibration Purposes.”
*Radiocarbon* 46 (3): 1273–98.
<https://doi.org/10.1017/S0033822200033142>.

</div>

<div id="ref-hua2013" class="csl-entry">

Hua, Quan, Mike Barbetti, and Andrzej Z Rakowski. 2013. “Atmospheric
Radiocarbon for the Period 1950–2010.” *Radiocarbon* 55 (4): 2059–72.
<https://doi.org/10.2458/azu_js_rc.v55i2.16177>.

</div>

<div id="ref-hua2022" class="csl-entry">

Hua, Quan, Jocelyn C Turnbull, Guaciara M Santos, et al. 2022.
“Atmospheric Radiocarbon for the Period 1950–2019.” *Radiocarbon* 64
(4): 723–45. <https://doi.org/10.1017/RDC.2021.95>.

</div>

<div id="ref-hughen2004" class="csl-entry">

Hughen, K., S. Lehman, J. Southon, et al. 2004. “14C Activity and Global
Carbon Cycle Changes over the Past 50,000 Years.” *Science* 303 (5655):
202–7. <https://doi.org/10.1126/science.1090300>.

</div>

<div id="ref-hughen2004a" class="csl-entry">

<span class="nocase">Hughen, Konrad A, Mike G L Baillie, Edouard Bard,
et al.</span> 2004. “Marine04 Marine Radiocarbon Age Calibration, 0–26
Cal Kyr BP.” *Radiocarbon* 46 (3): 1059–86.
<https://doi.org/10.1017/S0033822200033002>.

</div>

<div id="ref-hyndman1996" class="csl-entry">

Hyndman, Rob J. 1996. “Computing and Graphing Highest Density Regions.”
*The American Statistician* 50 (2): 120.
<https://doi.org/10.2307/2684423>.

</div>

<div id="ref-kueppers2004" class="csl-entry">

Kueppers, Lara M., John Southon, Paul Baer, and John Harte. 2004. “Dead
Wood Biomass and Turnover Time, Measured by Radiocarbon, Along a
Subalpine Elevation Gradient.” *Oecologia* 141 (4): 641–51.
<https://doi.org/10.1007/s00442-004-1689-x>.

</div>

<div id="ref-mccormac2004" class="csl-entry">

McCormac, F G, A G Hogg, P G Blackwell, C E Buck, T F G Higham, and P J
Reimer. 2004. “Shcal04 Southern Hemisphere Calibration, 0–11.0 Cal Kyr
BP.” *Radiocarbon* 46 (3): 1087–92.
<https://doi.org/10.1017/S0033822200033014>.

</div>

<div id="ref-millard2014" class="csl-entry">

Millard, Andrew R. 2014. “Conventions for Reporting Radiocarbon
Determinations.” *Radiocarbon* 56 (2): 555–59.
<https://doi.org/10.2458/56.17455>.

</div>

<div id="ref-reimer2009" class="csl-entry">

<span class="nocase">Reimer, P J, M G L Baillie, E Bard, et al.</span>
2009. “IntCal09 and Marine09 Radiocarbon Age Calibration Curves,
0–50,000 Years Cal BP.” *Radiocarbon* 51 (4): 1111–50.
<https://doi.org/10.1017/S0033822200034202>.

</div>

<div id="ref-reimer2020" class="csl-entry">

<span class="nocase">Reimer, Paula J, William E N Austin, Edouard Bard,
et al.</span> 2020. “The IntCal20 Northern Hemisphere Radiocarbon Age
Calibration Curve (0–55 Cal <span class="nocase">kBP</span>).”
*Radiocarbon* 62 (4): 725–57. <https://doi.org/10.1017/RDC.2020.41>.

</div>

<div id="ref-reimer2004" class="csl-entry">

<span class="nocase">Reimer, Paula J, Mike G L Baillie, Edouard Bard, et
al.</span> 2004. “Intcal04 Terrestrial Radiocarbon Age Calibration, 0–26
Cal Kyr BP.” *Radiocarbon* 46 (3): 1029–58.
<https://doi.org/10.1017/S0033822200032999>.

</div>

<div id="ref-reimer2013" class="csl-entry">

<span class="nocase">Reimer, Paula J, Edouard Bard, Alex Bayliss, et
al.</span> 2013. “IntCal13 and Marine13 Radiocarbon Age Calibration
Curves 0–50,000 Years Cal BP.” *Radiocarbon* 55 (4): 1869–87.
<https://doi.org/10.2458/azu_js_rc.55.16947>.

</div>

<div id="ref-stuiver1977" class="csl-entry">

Stuiver, Minze, and Henry A. Polach. 1977. “Discussion Reporting of 14C
Data.” *Radiocarbon* 19 (3): 355–63.
<https://doi.org/10.1017/S0033822200003672>.

</div>

<div id="ref-stuiver1998" class="csl-entry">

<span class="nocase">Stuiver, Minze, Paula J. Reimer, Edouard Bard, et
al.</span> 1998. “INTCAL98 Radiocarbon Age Calibration, 24,000–0 Cal
BP.” *Radiocarbon* 40 (3): 1041–83.
<https://doi.org/10.1017/S0033822200019123>.

</div>

<div id="ref-stuiver1998a" class="csl-entry">

Stuiver, Minze, Paula J. Reimer, and Thomas F. Braziunas. 1998.
“High-Precision Radiocarbon Age Calibration for Terrestrial and Marine
Samples.” *Radiocarbon* 40 (3): 1127–51.
<https://doi.org/10.1017/S0033822200019172>.

</div>

<div id="ref-vanderplicht2006" class="csl-entry">

<span class="nocase">van der Plicht, J, and A Hogg</span>. 2006. “A Note
on Reporting Radiocarbon.” *Quaternary Geochronology* 1 (4): 237–40.
<https://doi.org/10.1016/j.quageo.2006.07.001>.

</div>

<div id="ref-ward1978" class="csl-entry">

Ward, G. K., and S. R. Wilson. 1978. “Procedures for Comparing and
Combining Radiocarbon Age Determinations: A Critique.” *Archaeometry* 20
(1): 19–31. <https://doi.org/10.1111/j.1475-4754.1978.tb00208.x>.

</div>

</div>
