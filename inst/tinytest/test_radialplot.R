Sys.setenv(LANGUAGE = "en") # Force locale

using("tinysnapshot")
source("helpers.R")

data("ksarakil")

# Plot =========================================================================
radialplot_log <- function() radialplot(ksarakil$date, ksarakil$error, pch = 16)
expect_snapshot_plot(radialplot_log, "radialplot_log")

radialplot_bar <- function() radialplot(ksarakil$date, ksarakil$error, bar = TRUE, pch = 16)
expect_snapshot_plot(radialplot_bar, "radialplot_bar")

radialplot_nolog <- function() radialplot(ksarakil$date, ksarakil$error, log = FALSE, pch = 16)
expect_snapshot_plot(radialplot_nolog, "radialplot_nolog")
