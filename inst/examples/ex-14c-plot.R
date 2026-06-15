## Calibrate multiple dates
cal <- c14_calibrate(
  values = c(5000, 4500),
  errors = c(45, 35),
  names = c("X", "Y")
)

## Specify calendar
plot(cal, calendar = b2k(), flip = TRUE)

## HDR intervals (default)
plot(cal, interval = "hdr", level = 0.95)

## Credible intervals
plot(cal, interval = "credible", level = 0.95)

## No intervals
plot(cal, level = 0)
