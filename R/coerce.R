# COERCION
#' @include AllGenerics.R
NULL

# To list ======================================================================
#' @export
#' @method as.list CalibratedIntervals
as.list.CalibratedIntervals <- function(x, ..., calendar = get_calendar()) {
  z <- as.data.frame(x, calendar = calendar)
  f <- factor(z$label, levels = unique(z$label))
  z$label <- NULL
  split(x = z, f = f)
}

#' @export
#' @rdname as.list
#' @aliases as.list,CalibratedIntervals-method
setMethod("as.list", "CalibratedIntervals", as.list.CalibratedIntervals)

# To data.frame ================================================================
#' @export
#' @method as.data.frame CalibratedAges
as.data.frame.CalibratedAges <- function(x, ..., level = 0.954,
                                         calendar = get_calendar()) {
  int_hdr <- interval_hdr(x, level = level)
  int_fmt <- aion::format(int_hdr, calendar = calendar)
  int_txt <- sprintf("%s (%.1f%%)", int_fmt, int_hdr@p * 100)
  lab <- labels(int_hdr)
  int_ls <- split(int_txt, f = factor(lab, levels = unique(lab)))
  int <- vapply(
    X = int_ls,
    FUN = paste0,
    FUN.VALUE = character(1),
    collapse = " "
  )

  dens_x <- aion::time(x, calendar = calendar)
  dens_y <- x[, , 1, drop = FALSE]
  cal <- lapply(
    X = seq_len(ncol(dens_y)),
    FUN = function(i, x, y) {
      list(x = x, y = y[, i, drop = TRUE])
    },
    x = dens_x,
    y = dens_y
  )

  df <- data.frame(
    BP14C_value = x@values,
    BP14C_error = x@errors,
    reservoir_offset = x@reservoir_offsets,
    reservoir_error = x@reservoir_errors,
    calibration_curve = x@curves,
    calibration_hdr = int,
    calibration = I(cal), # List column
    row.names = labels(x)
  )

  if (isTRUE(x@F14C)) {
    names(df)[c(1L, 2L)] <- c("F14C_value", "F14C_error")
  }

  df
}

#' @export
#' @rdname as.data.frame
#' @aliases as.data.frame,CalibratedAges-method
setMethod("as.data.frame", "CalibratedAges", as.data.frame.CalibratedAges)

#' @export
#' @method as.data.frame CalibratedIntervals
as.data.frame.CalibratedIntervals <- function(x, ...,
                                              calendar = get_calendar()) {
  ## Build a data frame
  data.frame(
    label = labels(x),
    start = start(x, calendar = calendar),
    end = end(x, calendar = calendar),
    p = x@p
  )
}

#' @export
#' @rdname as.data.frame
#' @aliases as.data.frame,CalibratedIntervals-method
setMethod("as.data.frame", "CalibratedIntervals", as.data.frame.CalibratedIntervals)

#' @export
#' @method as.data.frame RECE
as.data.frame.RECE <- function(x, ..., calendar = get_calendar()) {
  dens <- x[, , 1, drop = TRUE]
  z <- data.frame(aion::time(x, calendar = calendar), dens)
  colnames(z) <- c("time", colnames(x) %||% paste0("X", seq_len(NCOL(x))))
  z
}

#' @export
#' @rdname as.data.frame
#' @aliases as.data.frame,RECE-method
setMethod("as.data.frame", "RECE", as.data.frame.RECE)

#' @export
#' @method as.data.frame ProxyRecord
as.data.frame.ProxyRecord <- function(x, ...,
                                      calendar = get_calendar()) {
  dens <- x[, , 1, drop = TRUE]
  z <- data.frame(aion::time(x, calendar = calendar), dens)
  colnames(z) <- c("time", colnames(x) %||% paste0("X", seq_len(NCOL(x))))
  z
}

#' @export
#' @rdname as.data.frame
#' @aliases as.data.frame,ProxyRecord-method
setMethod("as.data.frame", "ProxyRecord", as.data.frame.ProxyRecord)
