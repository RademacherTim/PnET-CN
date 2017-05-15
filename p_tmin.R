#==============================================================================#
# Plot climate forcing
#------------------------------------------------------------------------------#

#  Source libraries and data
#------------------------------------------------------------------------------#
source ('p_tmax.R')

# Prepare tmin
#------------------------------------------------------------------------------#
READ <- FALSE
if (READ) {
  tmin            <- matrix (NA, nrow = 117 * 12, ncol = 8)
  colnames (tmin) <- cnames
  
  # Put years and months into the tmax matirx
  #----------------------------------------------------------------------------#
  year       <- c (sapply (1901:2017, function (x) rep (x, 12)))
  tmin [, 1] <- year
  month      <- rep (1:12, 117)
  tmin [, 2] <- month
  
  # Daily weather data from HF weather station from 1964 to 2002
  #----------------------------------------------------------------------------#
  dates      <- as.Date (unlist (HF_arch_daily_1964_2002 [, 1]), "%m/%d/%Y")
  months     <- months (dates)
  months     <- match (months, months.abb)
  years      <- as.numeric (format (dates, format='%Y')) + 1900
  years      <- c (years [1:13149], 
                   years [13150:14061] + 100)
  t          <- data.frame (HF_arch_daily_1964_2002$airtmin, months, years)
  names (t)  <- c ('tmin','month','year')
  t          <- aggregate (tmin ~ month + year, t, mean) 
  t          <- t [order (t$year, t$month), ]
  t          <- rbind (t [1:368,   ], c (9,  1994, NA), # No value for September 1994, span for checking is 360:384
                       t [369:381, ], c (11, 1995, NA), # No value for November 1995
                                      c (12, 1995, NA), # No value for December 1995
                       t [382:length (t$tmin), ])
  tmin [, 3] <- c (rep (NA, 63*12), t$tmin, rep (NA, 186)) 
  
  # Monthly weather data from HF weather station 2002 to 2017
  #----------------------------------------------------------------------------#
  t          <- HF_arch_monthly_2002_2017 [, 6]
  tmin [, 4] <- c (rep (NA, 1202), t, rep (NA, 9))
  
  # PnET-CN monthly data file spanning 300 years
  #----------------------------------------------------------------------------#
  t          <- unlist (HF_monthly_300y$climIn [4])
  tmin [, 5] <- c (t [2401:length (t)], rep (NA, 20*12))
  
  # PnET-CN monthly data file spanning 1000 years
  #----------------------------------------------------------------------------#
  t          <- unlist (HF_monthly_1000y$climIn [4])
  tmin [, 6] <- t [4801:6204]
  
  # PnET-CN daily data file spanning three years
  #----------------------------------------------------------------------------#
  years      <- unlist (HF_daily$climIn [1])
  days       <- unlist (HF_daily$climIn [2])
  dates      <- strptime (paste (years, days), format="%Y %j")
  months     <- months (dates)
  months     <- match (months, months.abb)
  t          <- data.frame (HF_daily$climIn [4], months, years)
  names (t)  <- c ('tmin','month','year')
  t          <- aggregate (tmin ~ month + year, t, mean) 
  t          <- t [order (t$year, t$month), ]
  tmin [, 7] <- c (rep (NA, 90 * 12), t$tmin, rep (NA, 2 + 12 * 23))
  
  # Princeton climate data
  #----------------------------------------------------------------------------#
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
    
    path   <- '/Volumes/FINISTTR/data/raw/ISIMIP2/Input_Hist_obs/PGFv2/'
    #path   <- 'climIn/'
    ncname <- paste (path,'tasmin_pgfv2_',start,'_',end,'.nc4', sep = '')
    ncin   <- nc_open (ncname)
    #print (ncin)
    len    <- length (ncvar_get (ncin, 'time'))
    tmp    <- ncvar_get (ncin, 'tasmin', start = c (216, 95, 1), count = c (1, 1, len))
    # Harvard Forest is lat index 95 and lon index 216
    t      <- tmp - 273.15
    dates  <- seq.Date (from = as.Date (sdate), to = as.Date (edate), "day")
    years  <- as.numeric (format (dates, format='%Y'))
    months <- months (dates)
    months     <- match (months, months.abb)
    t      <- data.frame (t, months, years)
    names (t)  <- c ('tmin','month','year')
    t          <- aggregate (tmin ~ month + year, t, mean) 
    t          <- t [order (t$year, t$month), ]
    span <- (((syr - 1901) * 12) + 1):(((syr - 1901) * 12) + (eyr - syr + 1) * 12)
    tmin [span, 8] <- t$tmin
    print (paste ('Done with year: ',syr,' - ',eyr, sep = ''))
  }
  
  # Make a copy of this data.frame so I dont always have to read them in
  write.csv (tmin, 'climIn/tmin.csv', row.names = FALSE)
  
} else {
  # Read the stored copy of the data.frame
  tmin <- read.csv ('climIn/tmin.csv')  
}

# Plot overlapping years of the climate data
par (mar = c (5, 5, 1, 1))
plot (x    = tmin [1165:1248, 4],
      typ  = 'l',
      ylim = c (-15, 22),
      col  = '#91b9a4',
      xaxt = 'n',
      lwd  = 2,
      xlab = 'time',
      lty  = 2,
      ylab = expression (paste ('tmin (',degree,'C)')))
lines (x   = tmin [1165:1248, 3],
       col = '#990000',
       lwd = 2,
       lty = 4)
lines (x   = tmin [1165:1248, 7],
       col = '#8F2BBC66',
       lwd = 2,
       lty = 3)
lines (x   = tmin [1165:1248, 8],
       col = '#EE7F2D66', # Princeton Orange 
       lwd = 2)
axis (side   = 1, 
      at     = seq (6, 84, by = 12), # Show years label in june 
      labels = as.character (seq (1999, 2005, 1)))
legend (x = 1,
        y = 22,
        c ('Shaler', 'Fisher', 'Princeton'),
        col = c ('#990000','#91b9a4','#EE7F2D66'),
        lty = c (4,2,1),
        lwd = 2,
        box.lty = 0,
        bg  = 'transparent')
#==============================================================================#
