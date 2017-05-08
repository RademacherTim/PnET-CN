#==============================================================================#
# Plot climate forcing
#------------------------------------------------------------------------------#

# Matlab library
#------------------------------------------------------------------------------#
library (R.matlab)
library (lubridate)
library (ncdf4)

# Read climate data
#------------------------------------------------------------------------------#
HF_arch_daily_1964_2002   <- read.csv ('climIn/hf000-01-daily-m.csv') 
HF_arch_monthly_2002_2017 <- read.csv ('climIn/hf001-04-monthly-m.csv') 
HF_monthly_300y           <- readMat  ('climIn/hf_300y.mat')
HF_monthly_1000y          <- readMat  ('climIn/hf_1000y_avg.mat')
HF_daily                  <- readMat  ('climIn/hf_daily.mat')

# Prepare tair matirx
#------------------------------------------------------------------------------#
tair            <- matrix (NA, nrow = 117 * 12, ncol = 8)
colnames (tair) <- c ('year','month','HF_1','HF_2','PnET_1','PnET_2','PnET_3',
                      'Princeton')
months.abb <- c ('January','February','March','April','May','June','July','August',
                 'September','October','November','December')

# Put years and months into the tair matirx
#------------------------------------------------------------------------------#
year       <- c (sapply (1901:2017, function (x) rep (x, 12)))
tair [, 1] <- year
month      <- rep (1:12, 117)
tair [, 2] <- month

# Daily weather data from HF weather station from 1964 to 2002
#------------------------------------------------------------------------------#
dates      <- as.Date (unlist (HF_arch_daily_1964_2002 [, 1]), "%m/%d/%Y")
months     <- months (dates)
months     <- match (months, months.abb)
years      <- as.numeric (format (dates, format='%Y')) + 1900
years      <- c (years [1:13149], 
                 years [13150:14061] + 100)
t          <- data.frame (HF_arch_daily_1964_2002$airtmax, months, years)
names (t)  <- c ('tmax','month','year')
t          <- aggregate (tmax ~ month + year, t, mean) 
t          <- t [order (t$year, t$month), ]
t          <- rbind (t [1:368, ], c (9, 1994, NA), t [369:length (t [,1]), ])# It has no value for September 1994, span for checking is 360:372
tair [, 3] <- c (rep (NA, 63*12), t$tmax, rep (NA, 186)) 

# Monthly weather data from HF weather station 2002 to 2017
#------------------------------------------------------------------------------#
t          <- HF_arch_monthly_2002_2017 [, 4]
tair [, 4] <- c (rep (NA, 1202), t, rep (NA, 9))

# PnET-CN monthly data file
#------------------------------------------------------------------------------#
t          <- unlist (HF_monthly_300y$climIn [3])
tair [, 5] <- c (t [2401:length (t)], rep (NA, 20*12))

# PnET-CN monthly data file
#------------------------------------------------------------------------------#
t          <- unlist (HF_monthly_1000y$climIn [3])
tair [, 6] <- t [4801:6204]

# PnET-CN daily data file
#------------------------------------------------------------------------------#
years      <- unlist (HF_daily$climIn [1])
days       <- unlist (HF_daily$climIn [2])
dates      <- strptime (paste (years, days), format="%Y %j")
months     <- months (dates)
months     <- match (months, months.abb)
t          <- data.frame (HF_daily$climIn [3], months, years)
names (t)  <- c ('tmax','month','year')
t          <- aggregate (tmax ~ month + year, t, mean) 
t          <- t [order (t$year, t$month), ]
tair [, 6] <- c (rep (NA, 90 * 12), t$tmax, rep (NA, 2 + 12 * 23))

# Princeton climate data
#------------------------------------------------------------------------------#
for (syr in seq (1901, 2011, by = 10)) {
  start  <- as.character (syr)
  sdate  <- paste (start,'/01/01', sep = '')
  
  if (syr != 2011) {
    eyr <- syr + 9
  } else {
    eyr  <- 2012
  }
  end    <- as.character (eyr)
  edate  <- paste (end,'/12/31', sep = '')
  
  ncname <- paste ('/Volumes/FINISTTR/data/raw/ISIMIP2/Input_Hist_obs/PGFv2/tasmax_pgfv2_',
                       start,'_',end,'.nc4', sep = '')
  ncin   <- nc_open (ncname)
  #print (ncin)
  len    <- length (ncvar_get (ncin, 'time'))
  tmp    <- ncvar_get (ncin, 'tasmax', start = c (216, 95, 1), count = c (1, 1, len))
  # Harvard Forest is lat index 95 and lon index 216
  t      <- tmp - 273.15
  dates  <- seq.Date (from = as.Date (sdate), to = as.Date (edate), "day")
  years  <- as.numeric (format (dates, format='%Y'))
  months <- months (dates)
  months     <- match (months, months.abb)
  t      <- data.frame (t, months, years)
  names (t)  <- c ('tmax','month','year')
  t          <- aggregate (tmax ~ month + year, t, mean) 
  t          <- t [order (t$year, t$month), ]
  span <- (((syr - 1901) * 12) + 1):(((syr - 1901) * 12) + (eyr - syr + 1) * 12)
  tair [span, 8] <- t$tmax
  print (paste ('Done with year: ',syr,' - ',eyr, sep = ''))
}

# Plot overlapping years of the climate data
plot (x    = tair [1165:1248, 4],
      typ  = 'l',
      ylim = c (-5, 31),
      col  = '#91b9a4',
      xaxt = 'n',
      lwd  = 2,
      xlab = 'time',
      lty  = 2,
      ylab = expression (paste ('tmax (',degree,'C)')))
lines (x   = tair [1165:1248, 3],
       col = '#8F2BBC',
       lwd = 2,
       lty = 4)
lines (x   = tair [1165:1248, 8],
       col = '#99000066',
       lwd = 2)
axis (side   = 1, 
      at     = seq (6, 84, by = 12), # Show years label in june 
      labels = as.character (seq (1999, 2005, 1)))

# Plot from 1691 to 2021
plot (x    = unlist (HF_monthly_1000y$climIn [3]) [2391:6351],
      xaxt = 'n',
      typ  = 'l',
      ylab = 'tmax (degree C)',
      xlab = 'year')
axis (1, labels = as.character (seq (1691, 2021, 10)), at = seq (0, 3960, 120))

# Plot from 1901 to 2017
plot (x    = unlist (HF_monthly_1000y$climIn [3]) [4801:6204],
      xaxt = 'n',
      typ  = 'l',
      ylab = 'tmax (degree C)',
      xlab = 'year')
axis (1, labels = as.character (seq (1901, 2017, 10)), at = seq (0, 1404, 120))

# PLot from 1960 to 2017
plot (x    = unlist (HF_monthly_1000y$climIn [3]) [5521:6204],
      xaxt = 'n',
      typ  = 'l',
      ylab = 'tmax (degree C)',
      xlab = 'year')
axis (1, labels = as.character (seq (1961, 2017, 10)), at = seq (0, 684, 120))
lines (x   = unlist (HF_monthly_300y$climIn [3]) [2121:2805],
       )
#==============================================================================#