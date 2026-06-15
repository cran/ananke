# PLOT
#' @include AllGenerics.R
NULL

## 14C =========================================================================
#' @export
#' @method plot CalibratedAges
plot.CalibratedAges <- function(x, calendar = get_calendar(),
                                interval = c("hdr", "credible"),
                                level = 0.954, sort = TRUE, decreasing = FALSE,
                                col= "grey",
                                main = NULL, sub = NULL,
                                ann = graphics::par("ann"),
                                axes = TRUE, frame.plot = TRUE,
                                panel.first = NULL, panel.last = NULL, ...) {
  ## Check
  c14_validate(x)
  interval <- match.arg(interval, several.ok = FALSE)

  ## Sort
  if (isTRUE(sort)) {
    mid <- order(mean(x, calendar = NULL), decreasing = !decreasing)
    x <- x[, mid, , drop = FALSE]
  }

  ## Plot
  panel_density <- function(x, y, col, ...) {
    force(interval)
    force(level)

    ## Graphical parameters
    fill.density <- grDevices::adjustcolor(col, alpha.f = 0.5)
    fill.interval <- col

    tick_bottom <- min(y, na.rm = TRUE)
    tick_height <- tick_bottom + graphics::par("tcl") * graphics::strheight("M") * -1

    ## Keep only density > 0
    d0 <- which(y > tick_bottom)
    x <- x[d0]
    y <- y[d0]

    ## Draw density
    graphics::polygon(
      x = c(x, rev(x)),
      y = c(y, rep(tick_bottom, length(y))),
      border = NA,
      col = fill.density
    )

    ## Add interval
    if (isTRUE(level > 0)) {
      y0 <- arkhe::scale_range(y)
      int <- switch(
        interval,
        hdr = arkhe::interval_hdr(x, y0, level = level),
        credible = {
          spl <- sample(x, size = length(x), replace = TRUE, prob = y0)
          arkhe::interval_credible(spl, level = level)
        }
      )

      for (i in seq_len(nrow(int))) {
        debut <- int[i, "start"]
        fin <- int[i, "end"]
        if (debut < fin) is_in_int <- which(x >= debut & x <= fin)
        else is_in_int <- which(x <= debut & x >= fin)
        xi <- x[is_in_int]
        yi <- y[is_in_int]
        graphics::polygon(
          x = c(xi[1], xi, xi[length(xi)]),
          y = c(tick_bottom, yi, tick_bottom),
          border = NA, col = fill.interval
        )
        graphics::segments(
          x0 = c(debut, debut, fin),
          x1 = c(debut, fin, fin),
          y0 = c(tick_bottom, tick_bottom, tick_bottom),
          y1 = c(tick_height, tick_bottom, tick_height),
          lend = 1
        )
      }
    }

    graphics::lines(x, y, col = "black")
  }

  ## Method for TimeSeries
  methods::callNextMethod(
    x, facet = "multiple",
    calendar = calendar,
    panel = panel_density,
    main = main, sub = sub, ann = ann, axes = axes,
    frame.plot = frame.plot,
    panel.first = panel.first,
    panel.last = panel.last,
    col = col,
    ...
  )

  invisible(x)
}

#' @export
#' @rdname c14_plot
#' @aliases plot,CalibratedAges,missing-method
setMethod("plot", c(x = "CalibratedAges", y = "missing"), plot.CalibratedAges)

#' @export
#' @rdname ridgelines
#' @aliases ridgelines,CalibratedAges-method
setMethod(
  f = "ridgelines",
  signature = c(x = "CalibratedAges"),
  definition = function(x, calendar = get_calendar(),
                        interval = c("hdr", "credible"),
                        level = 0.954, fixed = TRUE, decreasing = FALSE,
                        col = "grey", ...) {
    ## Get data
    lab <- labels(x)

    ## Y scale
    if (isTRUE(fixed)) {
      mid <- mean(x, calendar = NULL)
      dy <- order(order(mid, decreasing = decreasing))
    } else {
      dy <- order(order(x@positions, decreasing = !decreasing))
    }
    for (j in seq_len(ncol(x))) x[, j, ] <- arkhe::scale_range(x[, j, ]) + dy[j]

    ## Permute
    x <- aion::flip(x)

    ## Plot
    plot(x, calendar = calendar, interval = interval, level = level,
         sort = FALSE, col = col,
         axes = FALSE, frame.plot = FALSE, yaxt = "n", ...)

    ## Construct Axis
    aion::year_axis(side = 1, format = TRUE, calendar = calendar, xpd = NA)
    graphics::axis(side = 2, at = dy, labels = lab, las = 2, lty = 0)
  }
)

## SPD =========================================================================
#' @export
#' @method plot CalibratedSPD
plot.CalibratedSPD <- function(x, calendar = get_calendar(),
                               main = NULL, sub = NULL,
                               ann = graphics::par("ann"),
                               axes = TRUE, frame.plot = TRUE,
                               panel.first = NULL, panel.last = NULL, ...) {
  ## Graphical parameters
  n <- NCOL(x)
  col <- list(...)$col %||% c("grey")
  if (length(col) != n) col <- rep(col, length.out = n)
  col <- grDevices::adjustcolor(col, alpha.f = 0.5)

  ## Plot
  panel_density <- function(x, y, ...) {
    graphics::polygon(
      x = c(x, rev(x)),
      y = c(y, rep(0, length(y))),
      border = NA,
      ...
    )
    graphics::lines(x, y, col = "black")
  }

  ## Method for TimeSeries
  methods::callNextMethod(
    x, facet = "multiple",
    calendar = calendar,
    panel = panel_density,
    main = main, sub = sub, ann = ann, axes = axes,
    frame.plot = frame.plot,
    panel.first = panel.first,
    panel.last = panel.last,
    col = col,
    ...
  )

  invisible(x)
}

#' @export
#' @rdname c14_plot
#' @aliases plot,CalibratedSPD,missing-method
setMethod("plot", c(x = "CalibratedSPD", y = "missing"), plot.CalibratedSPD)

## RECE ========================================================================
#' @export
#' @method plot RECE
plot.RECE <- function(x, calendar = get_calendar(), ...) {
  ## Binary array
  bin <- array(FALSE, dim = c(nrow(x), max(x), ncol(x)))
  for (j in seq_len(ncol(x))) {
    z <- x[, j, , drop = TRUE]
    for (i in seq_along(z)) {
      bin[i, z[i], j] <- z[i] > 0
    }
  }
  bin <- apply(X = bin, MARGIN = c(1, 2), FUN = sum)
  bin[bin == 0] <- NA

  ## Add annotation
  years <- aion::time(x, calendar = NULL)

  ## Plot
  graphics::image(
    x = years,
    y = seq_len(max(x)),
    z = log(bin),
    xlab = format(calendar),
    ylab = "Count",
    xaxt = "n",
    yaxt = "n",
    ...
  )

  ## Construct axes
  aion::year_axis(side = 1, format = TRUE, calendar = calendar,
                  current_calendar = NULL)
  graphics::axis(side = 2, at = seq_len(max(x)), las = 1)

  invisible(x)
}

#' @export
#' @rdname rec_plot
#' @aliases plot,RECE,missing-method
setMethod("plot", c(x = "RECE", y = "missing"), plot.RECE)


## Proxy =======================================================================
#' @export
#' @method plot ProxyRecord
plot.ProxyRecord <- function(x, calendar = get_calendar(),
                             iqr = TRUE,
                             xlab = NULL, ylab = NULL,
                             col = grDevices::hcl.colors(12, "YlOrRd", rev = TRUE),
                             col.mean = "black", col.iqr = col.mean,
                             lty.mean = 1, lty.iqr = 3,
                             lwd.mean = 2, lwd.iqr = lwd.mean, ...) {
  ## Get data
  years <- aion::time(x, calendar = NULL)
  z <- apply(
    X = x@density,
    MARGIN = 1,
    FUN = function(d) (d - min(d)) / max(d - min(d))
  )
  z[z == 0] <- NA

  ## Plot
  graphics::image(
    x = years,
    y = x@proxy,
    z = t(z),
    col = col,
    xaxt = "n",
    yaxt = "n",
    xlab = xlab %||% format(calendar),
    ylab = ylab %||% "Proxy",
    ...
  )

  ## Construct axes
  aion::year_axis(side = 1, format = TRUE, calendar = calendar,
                  current_calendar = NULL)
  graphics::axis(side = 2, las = 1)

  if (isTRUE(iqr)) {
    m <- mean(x)
    graphics::lines(x = years, y = m, col = col.mean,
                    lty = lty.mean, lwd = lwd.mean)

    q <- quantile(x, probs = c(0.25, 0.75))
    graphics::lines(x = years, y = q[, 1], col = col.iqr,
                    lty = lty.iqr, lwd = lwd.iqr)
    graphics::lines(x = years, y = q[, 2], col = col.iqr,
                    lty = lty.iqr, lwd = lwd.iqr)
  }

  invisible(x)
}

#' @export
#' @rdname proxy_plot
#' @aliases plot,ProxyRecord,missing-method
setMethod("plot", c(x = "ProxyRecord", y = "missing"), plot.ProxyRecord)
