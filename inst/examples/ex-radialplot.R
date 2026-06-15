## Data from Bosch et al. 2015
data("ksarakil")

## Radialplot
radialplot(ksarakil$date, ksarakil$error, pch = 16)

## Linear z-scale
radialplot(ksarakil$date, ksarakil$error, log = FALSE, pch = 16)
