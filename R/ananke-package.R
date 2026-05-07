#' @details
#'  \tabular{ll}{
#'   **Version** \tab 0.2.0 \cr
#'   **License** \tab GPL-3 \cr
#'   **CRAN DOI** \tab \doi{10.32614/CRAN.package.ananke} \cr
#'   **Zenodo DOI** \tab \doi{10.5281/zenodo.13236285} \cr
#'  }
#'
#'  Archéosciences Bordeaux (UMR 6034)\cr
#'  Maison de l'Archéologie\cr
#'  Université Bordeaux Montaigne\cr
#'  F-33607 Pessac cedex\cr
#'  France
#'
#' @section Package options:
#'  \pkg{ananke} uses the following [options()] to configure behavior:
#'  * `ananke.grid`: a [`numeric`] value specifying the number of equally
#'    spaced points at which densities are to be estimated (defaults to
#'    \eqn{512}). Should be a power of \eqn{2} (see [stats::density()]).
#'  * `ananke.round`: a [`character`] string specifying the rounding convention.
#'    It can be one of "`none`" (the default, no rounding) or "`stuiver`"
#'    (Stuiver & Polach, 1977).
#'  * `ananke.progress`: a [`logical`] scalar. Should progress bars be
#'    displayed? Defaults to [interactive()].
#'  * `ananke.verbose`: a [`logical`] scalar. Should \R report extra information
#'    on progress? Defaults to [interactive()].
#'
#' @name ananke-package
#' @aliases ananke
#' @docType package
#' @keywords internal
"_PACKAGE"

#' @import aion
#' @import arkhe
#' @import methods
NULL
