#==============================================================================#
# Plot climate forcing
#------------------------------------------------------------------------------#

# Matlab library
#------------------------------------------------------------------------------#
library (R.matlab)
library (lubridate)
library (ncdf4)

# Read cliamte data
#------------------------------------------------------------------------------#
HF_arch_daily_1964_2002   <- read.csv ('climIn/hf000-01-daily-m.csv') 
HF_arch_monthly_2002_2017 <- read.csv ('climIn/hf001-04-monthly-m.csv') 
HF_monthly_300y           <- readMat  ('climIn/hf_300y.mat')
HF_monthly_1000y          <- readMat  ('climIn/hf_1000y_avg.mat')
HF_daily                  <- readMat  ('climIn/hf_daily.mat')

# Create data.frame of monthly means of daily tmax
#------------------------------------------------------------------------------#
tair            <- matrix (NA, nrow = 117 * 12, ncol = 8)
colnames (tair) <- c ('year','month','HF_1','HF_2','PnET_1','PnET_2','PnET_3',
                      'Princeton')
#
#------------------------------------------------------------------------------#
year       <- c (sapply (1901:2017, function (x) rep (x, 12)))
tair [, 1] <- year

#
#------------------------------------------------------------------------------#
month      <- rep (1:12, 117)
tair [, 2] <- month

# Daily weather data from HF weather station from 1964 to 2002
#------------------------------------------------------------------------------#
dates      <- as.Date (unlist (HF_arch_daily_1964_2002 [, 1]), "%m/%d/%Y")
months     <- months (dates)
years      <- format (dates, format='%y')
t          <- data.frame (HF_arch_daily_1964_2002$airt, months, years)
names (t)  <- c ('tmax','month','year')
t          <- aggregate (tmax ~ month + year, t, mean) 
tair [, 3] <- c (rep (NA, 63*12), t$tmax, rep (NA, 189)) 

# Monthly weather data from HF weather station 2002 to 2017
#------------------------------------------------------------------------------#
t          <- HF_arch_monthly_2002_2017 [, 8]
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
t          <- data.frame (HF_daily$climIn [3], months, years)
names (t)  <- c ('tmax','month','year')
t          <- aggregate (tmax ~ month + year, t, mean) 
tair [, 6] <- c (rep (NA, 90 * 12), t$tmax, rep (NA, 2 + 12 * 23))


# Princeton climate data
#------------------------------------------------------------------------------#
for (syr in seq (1901, 2011, by = 10)) {
  start  <- as.character (syr)
  sdate  <- paste (start,'/01/01', sep = '')
  
  if (syr != 2011) {
    end  <- as.character (syr + 9)
  } else {
    end  <- '2012'
  }
  edate  <- paste (end,'/12/31', sep = '')
  
  ncname <- paste ('/Volumes/FINISTTR/data/raw/ISIMIP2/Input_Hist_obs/PGFv2/tasmax_pgfv2_',
                       start,'_',end,'.nc4', sep = '')
  ncin   <- nc_open (ncname)
  #print (ncin)
  tmp    <- ncvar_get (ncin, 'tasmax')
  # Harvard Forest is lat index 95 and lon index 216
  t      <- tmp [216, 95, ] - 273.15
  dates  <- seq.Date (from = as.Date (sdate), to = as.Date (edate), "day")
  years  <- format (dates, format='%y')
  months <- months (dates)
  t      <- data.frame (t, months, years)
  tair 
}


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