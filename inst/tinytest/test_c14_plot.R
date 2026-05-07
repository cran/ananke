Sys.setenv(LANGUAGE = "en") # Force locale

using("tinysnapshot")
source("helpers.R")

# Calibrate ====================================================================
cal <- c14_calibrate(
  values = c(5000, 4500, 3000),
  errors = c(45, 35, 35),
  names = c("X", "Y", "Z")
)

# Plot =========================================================================
plot_cal_hdr_decr <- function() plot(cal, level = 0.68, decreasing = TRUE)
expect_snapshot_plot(plot_cal_hdr_decr, "plot_cal_hdr_decr")

plot_cal_hdr_incr <- function() plot(cal, level = 0.68, decreasing = FALSE)
expect_snapshot_plot(plot_cal_hdr_incr, "plot_cal_hdr_incr")

plot_cal_cred_decr <- function() with_seed(12345, plot(cal, level = 0.68, interval = "cred", decreasing = TRUE))
expect_snapshot_plot(plot_cal_cred_decr, "plot_cal_cred_decr")

plot_cal_cred_incr <- function() with_seed(12345, plot(cal, level = 0.68, interval = "cred", decreasing = FALSE))
expect_snapshot_plot(plot_cal_cred_incr, "plot_cal_cred_incr")

# Ridgelines ===================================================================
ridge_cal_decr <- function() ridgelines(cal, level = 0.68, fixed = TRUE, decreasing = TRUE)
expect_snapshot_plot(ridge_cal_decr, "ridge_cal_decr")

ridge_cal_incr <- function() ridgelines(cal, level = 0.68, fixed = TRUE, decreasing = FALSE)
expect_snapshot_plot(ridge_cal_incr, "ridge_cal_incr")
