## Calibrate multiple dates
cal <- c14_calibrate(
  values = c(5000, 4500),
  errors = c(45, 35),
  names = c("X", "Y")
)

## Ridgelines plot
ridgelines(cal, panel.first = graphics::grid())

## Change colors
ridgelines(cal, col = c("red", "blue"))
