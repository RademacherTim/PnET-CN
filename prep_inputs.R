#=======================================================================================#
# Make a Princeton data input file
#---------------------------------------------------------------------------------------#

# Read climate inputs
#---------------------------------------------------------------------------------------#
source ('p_tmax.R')
source ('p_tmin.R')
source ('p_rads.R')
source ('p_prec.R')

start_year <- 1001
end_year   <- 2012
period     <- end_year - start_year + 1
year_P     <-  as.vector (sapply (start_year:end_year, function (x) rep (x, 12)))
CO2_RCP8p5 <- read.table ('climIn/RCP85_MIDYEAR_CONCENTRATIONS.txt', skip = 39) [4]
CO2_P      <- c (rep (rep (CO2_RCP8p5$V4 [1], 12), 1764 - start_year + 1), as.vector (sapply (1:(end_year - 1765 + 1), function (x) rep (CO2_RCP8p5$V4 [x], 12))))
#plot (year_P, CO2_P)
# I could seasonal variation in CO2 by making it a sinusoidal function of the doy
doy    <- rep (c (15,46,74,105,135,166,196,227,258,288,319,349),  period)
tmax_P <- c (rep (tmax$Princeton [1:360], 30), tmax$Princeton [1:(12 * 112)]) 
tmin_P <- c (rep (tmin$Princeton [1:360], 30), tmin$Princeton [1:(12 * 112)]) 
prec_P <- c (rep (prec$Princeton [1:360], 30), prec$Princeton [1:(12 * 112)]) 
par_P  <- c (rep (rads$Princeton [1:360], 30), rads$Princeton [1:(12 * 112)]) 

# Write data into matlab structure to run PnET-CN with it
#---------------------------------------------------------------------------------------#
writeMAT (con    = 'Princeton.mat', 
          year   = year_P, 
          doy    = doy_P, 
          tmax   = tmax_P, 
          tmin   = tmin_P, 
          par    = ,
          prec   = prec_P,
          O3     = ,
          CO2    = ,
          NH4dep = ,
          NH3dep = )

#=======================================================================================#