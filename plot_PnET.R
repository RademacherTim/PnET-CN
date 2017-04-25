#==============================================================================#
# Read the output data of PnET-CN to plot it
#------------------------------------------------------------------------------#

# load libraries
#------------------------------------------------------------------------------#
library (R.matlab)

months <- c ('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec')

# Read data files
data0    <- readMat ('outputs/out_no_pool_control.mat')
data1    <- readMat ('outputs/out_one_pool_control.mat')
data2    <- readMat ('outputs/out_two_pool_control.mat')
data0.1  <- readMat ('outputs/out_no_pool_0p75.mat')
data1.1  <- readMat ('outputs/out_one_pool_0p75.mat')
data2.1  <- readMat ('outputs/out_two_pool_0p75.mat')

# Get Carbon Cycle variables for no pool model
plantcMo0 <- as.numeric (unlist (data0$out [ 7]))
budcMo0   <- as.numeric (unlist (data0$out [ 8]))
woodcMo0  <- as.numeric (unlist (data0$out [ 9]))
rootcMo0  <- as.numeric (unlist (data0$out [10]))

# Get Carbon Cycle variables for standard
plantcMo1    <- as.numeric (unlist (data1$out [ 7]))
budcMo1      <- as.numeric (unlist (data1$out [ 8]))
woodcMo1     <- as.numeric (unlist (data1$out [ 9]))
rootcMo1     <- as.numeric (unlist (data1$out [10]))

# Get Carbon Cycle variables for fast slow pool model
plantcMo2     <- as.numeric (unlist (data2$out [ 7]))
plantcfastMo2 <- as.numeric (unlist (data2$out [ 8]))
plantcslowMo2 <- as.numeric (unlist (data2$out [ 9]))
budcMo2       <- as.numeric (unlist (data2$out [10]))
woodcMo2      <- as.numeric (unlist (data2$out [11]))
rootcMo2      <- as.numeric (unlist (data2$out [12]))


# Bookkeeing to account for the NSC that is invested in wood and foliage formation
plantNSC0 <- array (NA, dim = 3564); plantNSC1 <- array (NA, dim = 3564); plantNSC2 <- array (NA, dim = 3564)
year = 0
for (yr in 1:297){
  year = year + 1
  for (mon in 1:12) {
    if (mon < 4) {
      plantNSC0     [(year - 1) * 12 + mon] <- plantcMo0     [(year - 1) * 12 + mon] + woodcMo0 [(year - 1) * 12 + mon] + budcMo0 [(year - 1) * 12 + mon]
      plantNSC1     [(year - 1) * 12 + mon] <- plantcMo1     [(year - 1) * 12 + mon] + woodcMo1 [(year - 1) * 12 + mon] + budcMo1 [(year - 1) * 12 + mon]
      plantNSC2     [(year - 1) * 12 + mon] <- plantcMo2     [(year - 1) * 12 + mon] + woodcMo2 [(year - 1) * 12 + mon] + budcMo2 [(year - 1) * 12 + mon]
      plantcfastMo2 [(year - 1) * 12 + mon] <- plantcfastMo2 [(year - 1) * 12 + mon] + woodcMo2 [(year - 1) * 12 + mon] + budcMo2 [(year - 1) * 12 + mon]
    } else {
      plantNSC0     [(year - 1) * 12 + mon] <- plantcMo0     [(year - 1) * 12 + mon]
      plantNSC1     [(year - 1) * 12 + mon] <- plantcMo1     [(year - 1) * 12 + mon]
      plantNSC2     [(year - 1) * 12 + mon] <- plantcMo2     [(year - 1) * 12 + mon]
      plantcfastMo2 [(year - 1) * 12 + mon] <- plantcfastMo2 [(year - 1) * 12 + mon]
    }
  }
}

# Extract for 1901-1996 and sum for total NSC budget
plantNSC0 <- plantNSC0 [2413:3564]; plantNSC1 <- plantNSC1 [2413:3564]; plantNSC2 <- plantNSC2 [2413:3564]
plantcMo0 <- plantcMo0 [2413:3564]; plantcMo1 <- plantcMo1 [2413:3564]; plantcMo2 <- plantcMo2 [2413:3564]
budcMo0   <- budcMo0   [2413:3564]; budcMo1   <- budcMo1   [2413:3564]; budcMo2   <- budcMo2   [2413:3564] 
woodcMo0  <- woodcMo0  [2413:3564]; woodcMo1  <- woodcMo1  [2413:3564]; woodcMo2  <- woodcMo2  [2413:3564]
rootcMo0  <- rootcMo0  [2413:3564]; rootcMo1  <- rootcMo1  [2413:3564]; rootcMo2  <- rootcMo2  [2413:3564] 

# Get mean-period monthly values 
aveplantc0    <- sapply (1:12, function (x) mean (plantcMo0     [seq (x,  length (plantcMo0), 12)]))
avebudc0      <- sapply (1:12, function (x) mean (budcMo0       [seq (x,  length (budcMo0),   12)]))
avewoodc0     <- sapply (1:12, function (x) mean (woodcMo0      [seq (x,  length (woodcMo0),  12)]))
averootc0     <- sapply (1:12, function (x) mean (rootcMo0      [seq (x,  length (rootcMo0),  12)]))
avePlantNSC0  <- c (aveplantc0 [1:3] + avewoodc0 [1] + avebudc0 [1], aveplantc0 [4:12])

aveplantc1    <- sapply (1:12, function (x) mean (plantcMo1     [seq (x,  length (plantcMo1), 12)]))
avebudc1      <- sapply (1:12, function (x) mean (budcMo1       [seq (x,  length (budcMo1),   12)]))
avewoodc1     <- sapply (1:12, function (x) mean (woodcMo1      [seq (x,  length (woodcMo1),  12)]))
averootc1     <- sapply (1:12, function (x) mean (rootcMo1      [seq (x,  length (rootcMo1),  12)]))
avePlantNSC1  <- c (aveplantc1 [1:3] + avewoodc1 [1] + avebudc1 [1], aveplantc1 [4:12])

avePlantCfast2 <- sapply (1:12, function (x) mean (plantcfastMo2 [seq (x,  length (plantNSC2), 12)]))
avePlantCslow2 <- sapply (1:12, function (x) mean (plantcslowMo2 [seq (x,  length (plantNSC2), 12)]))
aveplantc2     <- sapply (1:12, function (x) mean (plantcMo2     [seq (x,  length (plantcMo2), 12)]))
avebudc2       <- sapply (1:12, function (x) mean (budcMo2       [seq (x,  length (budcMo2),   12)]))
avewoodc2      <- sapply (1:12, function (x) mean (woodcMo2      [seq (x,  length (woodcMo2),  12)]))
averootc2      <- sapply (1:12, function (x) mean (rootcMo2      [seq (x,  length (rootcMo2),  12)]))
avePlantNSC2   <- c (aveplantc2 [1:3] + avewoodc2 [1] + avebudc2 [1], aveplantc2    [4:12]) # Should it just be the fast plant carbon?

# Plot standard representation
par (mar = c (5, 5, 1, 1))
par (mfrow = c (3, 1))
plot (x    = avePlantNSC0, 
      typ  = 'l',
      xlab = 'month',
      ylab = expression (paste ('NSCs (gC ',m^-2,')')),
      ylim = c (0, 2700),
      xlim = c (1, 12),
      xaxt = 'n',
      lwd  = 2,
      col  = 'white')
annual_lines <- sapply (1:96, function (x) lines (plantNSC0 [(x - 1) * 12 + 1:(x * 12)], lwd = 0.1, col = 'darkgrey'))
axis (1, labels = months, at = 1:12)
legend (1, 2700, c ('mean','annual'), box.lty = 0, col = c ('darkgrey','darkgrey'), lwd = c (2, 0.1))
rect (xleft   = 12, 
      ybottom = 0,
      xright  = 13,
      ytop    = 2000,
      col     = 'white',
      lty     = 0)
lines (avePlantNSC0,  col = 'darkgrey', lwd = 2)
box ()
text (12.2, 2500, 'NULL')

plot (x    = avePlantNSC1, 
      typ  = 'l',
      xlab = 'month',
      ylab = expression (paste ('NSCs (gC ',m^-2,')')),
      ylim = c (0, 2700),
      xlim = c (1, 12),
      xaxt = 'n',
      lwd  = 2,
      col  = 'white')
annual_lines <- sapply (1:96, function (x) lines (plantNSC1 [(x - 1) * 12 + 1:(x * 12)], lwd = 0.1, col = 'darkgrey'))
axis (1, labels = months, at = 1:12)
legend (1, 2700, c ('mean','annual'), box.lty = 0, col = c ('darkgrey','darkgrey'), lwd = c (2, 0.1))
rect (xleft   = 12, 
      ybottom = 0,
      xright  = 13,
      ytop    = 2000,
      col     = 'white',
      lty     = 0)
lines (avePlantNSC1,  col = 'darkgrey', lwd = 2)
box ()
text (12.2, 2500, 'ONE')

#
plot (x    = avePlantNSC2, 
      typ  = 'l', 
      lwd  = 1, 
      ylim = c (0, 2700), 
      col  = 'white', 
      ylab = expression (paste ('NSCs (gC ',m^-2,')')),
      xlab = 'month',
      xlim = c (1, 12),
      xaxt = 'n')
axis (1, labels = months, at = 1:12)
annual_lines <- sapply (1:96, function (x) lines (plantNSC2     [(x - 1) * 12 + 1:(x * 12)], lwd = 0.1, col = 'darkgrey'))
annual_lines <- sapply (1:96, function (x) lines (plantcfastMo2 [(x - 1) * 12 + 1:(x * 12)], lwd = 0.1, col = 'darkred'))
annual_lines <- sapply (1:96, function (x) lines (plantcslowMo2 [(x - 1) * 12 + 1:(x * 12)], lwd = 0.1, col = 'darkblue'))
legend (1, 2700, c ('total','fast','slow'), box.lty = 0, col = c ('darkgrey','darkred','darkblue'), lwd = 2,
        bg = 'transparent')
rect (xleft   = 12, 
      ybottom = 0,
      xright  = 13,
      ytop    = 4000,
      col     = 'white',
      lty     = 0)
lines (avePlantNSC2,   col = 'darkgrey', lwd = 2)
lines (avePlantCslow2, col = 'darkblue', lwd = 2)
lines (avePlantCfast2, col = 'darkred',  lwd = 2)
box ()
text (12.2, 2500, 'TWO')
#==============================================================================#