# RADIALPLOT
#' @include AllGenerics.R
NULL

coord_ellipse <- function(x, center, radius, log = TRUE, asp = 1) {
  z <- if (isTRUE(log)) log(x) else x
  ptx <- radius / sqrt(1 + asp^2 * (z - center)^2)
  pty <- (z - center) * ptx
  list(x = ptx, y = pty, labels = x)
}
arc <- function(from, to, center, radius, n = 100, log = TRUE, asp = 1,
                col = graphics::par("col"), lty = graphics::par("lty"),
                lwd = graphics::par("lwd")) {

  x <- seq(from = from, to = to, length.out = n)
  pt <- coord_ellipse(x, center, radius, log, asp)

  graphics::lines(pt$x, pt$y, col = col, lty = lty, lwd = lwd)
}

#' @export
#' @rdname radialplot
#' @aliases radialplot,numeric,numeric-method
setMethod(
  f = "radialplot",
  signature = c(values = "numeric", errors = "numeric"),
  definition = function(values, errors, log = TRUE,
                        centrality = c("weighted.mean", "mean", "median"),
                        bar = FALSE, grid = TRUE,
                        main = NULL, sub = NULL,
                        ann = graphics::par("ann"), ...) {
    ## Validation
    n <- length(values)
    if (n < 2) {
      stop(tr_("At least two data points are needed."), call. = FALSE)
    }
    arkhe::assert_length(errors, n)

    ## Measured values
    z <- if (isTRUE(log)) log(values) else values
    ## Standard error associated with z
    se <- if (isTRUE(log)) errors / values else errors

    ## Central value of z
    if (is.character(centrality)) {
      centrality <- match.arg(centrality, several.ok = FALSE)
      center <- switch(
        centrality,
        mean = mean(z, na.rm = TRUE),
        median = median(z, na.rm = TRUE),
        weighted.mean = stats::weighted.mean(z, w = 1 / se^2)
      )
    } else if (is.numeric(centrality)) {
      center <- if (isTRUE(log)) log(centrality) else centrality
    } else {
      arkhe::assert_type(centrality, "character")
    }
    arkhe::assert_length(center, 1)

    ## Precision (x axis)
    precision <- 1 / se

    ## Individual standardized estimate (y axis)
    std_est <- (z - center) / se

    ## Aspect ratio
    ratio <- (max(precision) - min(precision)) / (max(std_est) - min(std_est))

    ## Compute arc on the right (z axis)
    r0 <- max(precision) * 1.05
    ## Primary ticks
    r1 <- max(precision) * 1.06
    ticks_primary <- pretty(values, n = 5)
    zticks0 <- coord_ellipse(ticks_primary, center, r0, log, asp = ratio)
    zticks1 <- coord_ellipse(ticks_primary, center, r1, log, asp = ratio)
    ## Secondary ticks
    r2 <- max(precision) * 1.055
    ticks_secondary <- seq(from = min(ticks_primary), to = max(ticks_primary),
                           length.out = (3 * length(ticks_primary)) - 2)
    zticks2 <- coord_ellipse(ticks_secondary, center, r0, log, asp = ratio)
    zticks3 <- coord_ellipse(ticks_secondary, center, r2, log, asp = ratio)

    ## Graphical parameters
    old_par <- graphics::par(xpd = TRUE)
    on.exit(graphics::par(old_par))

    ## Open new window
    grDevices::dev.hold()
    on.exit(grDevices::dev.flush(), add = TRUE)
    graphics::plot.new()

    ## Set plotting coordinates
    xticks <- pretty(c(0, precision))
    yticks <- c(-2, 0, 2)
    xlim <- range(0, precision, xticks, zticks1$x, zticks3$x)
    ylim <- range(std_est, yticks, zticks1$y, zticks3$y) * 1.5
    graphics::plot.window(xlim = xlim, ylim = ylim, xaxs = "i")

    ## Grid
    if (isTRUE(bar)) {
      graphics::rect(xleft = 0, ybottom = -2,
                     xright = max(precision) * 1.01, ytop = 2,
                     border = NA, col = "grey80")
    }
    if (isTRUE(grid)) {
      graphics::segments(x0 = 0, x1 = zticks0$x, y0 = 0, y1 = zticks0$y,
                         lty = 2, col = "grey70")
    }

    ## Plot
    graphics::points(x = precision, y = std_est, ...)

    ## Construct axis
    graphics::axis(side = 2, at = yticks, las = 1)
    graphics::axis(side = 1, at = xticks)
    graphics::axis(
      side = 3,
      at = xticks[xticks != 0],
      labels = round(1 / xticks[xticks != 0], digits = 3),
      pos = graphics::par("usr")[[3L]]
    )

    theta_range <- range(zticks0$labels, zticks2$labels)
    arc(from = theta_range[1L], to =  theta_range[2L], center = center,
        radius = r0, n = 100, log = log, asp = ratio)
    graphics::segments(x0 = zticks0$x, x1 = zticks1$x,
                       y0 = zticks0$y, y1 = zticks1$y)
    graphics::segments(x0 = zticks2$x, x1 = zticks3$x,
                       y0 = zticks2$y, y1 = zticks3$y)
    graphics::text(x = zticks1$x, y = zticks1$y,
                   labels = zticks1$labels, pos = 4)

    ## Add annotation
    if (ann) {
      xlab1 <- tr_("Precision")
      xlab2 <- ifelse(isTRUE(log), tr_("Relative standard error"), tr_("Standard error"))
      ylab <- tr_("Standardised estimates")
      graphics::title(main = main, sub = sub, xlab = xlab1, ylab = ylab)
      graphics::mtext(xlab2, side = 1, line = -4)
    }

    invisible(list(values = values, errors = errors))
  }
)

#' @export
#' @rdname radialplot
#' @aliases radialplot,CalibratedAges,missing-method
setMethod(
  f = "radialplot",
  signature = c(values = "CalibratedAges", errors = "missing"),
  definition = function(values, log = TRUE,
                        centrality = c("weighted.mean", "mean", "median"),
                        bar = FALSE, grid = TRUE, main = NULL, sub = NULL,
                        ann = graphics::par("ann"), ...) {

    methods::callGeneric(values = values@values, errors = values@errors,
                         log = log, centrality = centrality,
                         bar = bar, grid = grid, main = main, sub = sub,
                         ann = ann, ...)

    invisible(values)
  }
)
