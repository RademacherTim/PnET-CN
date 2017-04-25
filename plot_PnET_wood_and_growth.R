# Get matlab library and data files
source ('plot_PnET.R')

# Get wood specific variables from output files
woodm0       <- as.numeric (unlist (data0$out   [35]))
woodm1       <- as.numeric (unlist (data1$out   [35]))
woodm2       <- as.numeric (unlist (data2$out   [35]))
woodm0.1     <- as.numeric (unlist (data0.1$out [35]))
woodm1.1     <- as.numeric (unlist (data1.1$out [35]))
woodm2.1     <- as.numeric (unlist (data2.1$out [35]))

# Get growth in woody biomass
dwoodm0   = woodm0   [2:297] - woodm0   [1:296]
dwoodm1   = woodm1   [2:297] - woodm1   [1:296]
dwoodm2   = woodm2   [2:297] - woodm2   [1:296]
dwoodm0.1 = woodm0.1 [2:297] - woodm0.1 [1:296]
dwoodm1.1 = woodm1.1 [2:297] - woodm1.1 [1:296]
dwoodm2.1 = woodm2.1 [2:297] - woodm2.1 [1:296]

# Plot monthly wood carbon for 1901-1996
par (mfrow = c (3, 1))
plot (x    = woodm0 [201:297],
      typ  = 'l',
      ylim = c (19000, 30000),
      xaxt = 'n',
      lty  = 1,
      xlab = 'Year',
      col  = 'darkgrey',
      ylab = expression (paste ('Wood mass (g ',m^-2,' ',yr^-1,')')))
axis (1, labels = c ('1900','1910','1920','1930','1940','1950','1960','1970','1980','1990','2000'), at = seq (0, 100, 10))
lines (x   = woodm0.1 [201:297], 
       lty = 2,
       col = 'darkgrey')
lines (x   = woodm1   [201:297], 
       lty = 1,
       col = 'purple')
lines (x   = woodm1.1 [201:297], 
       lty = 2,
       col = 'purple')
lines (x   = woodm2   [201:297], 
       lty = 1,
       col = 'darkgreen')
lines (x   = woodm2.1 [201:297], 
       lty = 2,
       col = 'darkgreen')
legend (x       = 1,
        y       = 30000,
        legend  = c ('NULL','ONE',"TWO"),
        lty     = c (3, 2, 1),
        col     = c ('black','purple','darkgreen'),
        box.lty = 0,
        bg      = 'transparent')

plot (x    = dwoodm0 [201:297],
      typ  = 'l',
      ylim = c (-200, 250),
      lty  = 1,
      xaxt = 'n',
      xlab = 'Year',
      col  = 'darkgrey',
      ylab = expression (paste ('Wood mass increment (g ',m^-2,' ',yr^-1,')')))
axis (1, labels = c ('1900','1910','1920','1930','1940','1950','1960','1970','1980','1990','2000'), at = seq (0, 100, 10))
lines (x = dwoodm0.1 [201:297], 
       lty = 2,
       col = 'darkgrey')
lines (x = dwoodm1   [201:297], 
       lty = 1,
       col = 'purple')
lines (x = dwoodm1.1 [201:297], 
       lty = 2,
       col = 'purple')
lines (x = dwoodm2   [201:297], 
       lty = 1,
       col = 'darkgreen')
lines (x = dwoodm2.1 [201:297], 
       lty = 2,
       col = 'darkgreen')
legend (x       = 1,
        y       = 250,
        legend  = c ('NULL','ONE','TWO'),
        lty     = c (3, 2, 1),
        col     = c ('black','purple','darkgreen'),
        box.lty = 0,
        bg      = 'transparent')

#plot (x    = woodcMo0, 
#      typ  = 'l', 
#      lty  = 1,
#      xlab = 'Year',
#      xaxt = 'n',
#      col  = 'darkgrey',
#      ylab = expression (paste ('Allocation of C to wood (gC ',m^-2,' ',yr^-1,')')),
#      ylim = c (150, 390))
#axis (1, labels = c ('1900','1910','1920','1930','1940','1950','1960','1970','1980','1990'), at = seq (0, 1152, 120))
#lines (x   = woodcMo0.1, 
#       lty = 2,
#       col = 'darkgrey')
#lines (x   = woodcMo1, 
#       lty = 1,
#       col = 'purple')
#lines (x   = woodcMo1.1, 
#       lty = 2,
#       col = 'purple')
#lines (x   = woodcMo2, 
#       lty = 1,
#       col = 'darkgreen')
#lines (x   = woodcMo2.1, 
#       lty = 2,
#       col = 'darkgreen')
#legend (x       = 1,
#        y       = 395,
#        legend  = c ('NULL','ONE','TWO'),
#        lty     = c (3, 2, 1),
#        col     = c ('black','purple','darkgreen'),
#        box.lty = 0,
#        bg      = 'transparent')


# Determine autocorrelation of wood mass increment
fit0.ac   <- acf (dwoodm0)
fit1.ac   <- acf (dwoodm1)
fit2.ac   <- acf (dwoodm2)
fit0.1.ac <- acf (dwoodm0.1)
fit1.1.ac <- acf (dwoodm1.1)
fit2.1.ac <- acf (dwoodm2.1)
par (mfrow = c (1, 1))
plot (fit0.ac$acf,
      typ = 'l',
      xlab = 'lag (years)',
      ylab = 'autocorrelation coefficients',
      lty = 3)
lines (fit1.ac$acf,
       lty = 2,
       col = 'purple')
lines (fit2.ac$acf,
       lty = 1,
       col = 'darkgreen')
legend (20, 1.0,
        legend = c ('NULL','ONE','TWO'),
        col = c ('black','purple','darkgreen'),
        lty = c (3,2,1),
        box.lty = 0,
        bg = 'transparent')

# Determine autocorrelation of nppwood
fit0.ac   <- acf (as.numeric (unlist (data0$out   [17])))
fit1.ac   <- acf (as.numeric (unlist (data1$out   [17])))
fit2.ac   <- acf (as.numeric (unlist (data2$out   [17])))
fit0.1.ac <- acf (as.numeric (unlist (data0.1$out [17])))
fit1.1.ac <- acf (as.numeric (unlist (data1.1$out [17])))
fit2.1.ac <- acf (as.numeric (unlist (data2.1$out [17])))
par (mfrow = c (1, 1))
plot (x    = fit0.ac$acf,
      typ  = 'l',
      xlab = 'lag (years)',
      ylab = 'autocorrelation coefficients',
      lty  = 1,
      col  = 'darkgrey')
lines (x   = fit0.1.ac$acf, 
       lty = 2, 
       col = 'darkgrey')
lines (x   = fit1.ac$acf,
       lty = 1,
       col = 'purple')
lines (x   = fit1.1.ac$acf, lty = 2, col = 'purple')
lines (x   = fit2.ac$acf,
       lty = 1,
       col = 'darkgreen')
lines (x   = fit2.1.ac$acf, lty = 2, col = 'darkgreen')
legend (20, 1.0,
        legend = c ('NULL','ONE','TWO'),
        col = c ('black','purple','darkgreen'),
        lty = 1,
        box.lty = 0,
        bg = 'transparent')

# Linear models without autocorrelation
years <- 1900:1996
dat <- data.frame (cbind (years, woodm0 [201:297], woodm1 [201:297], woodm2 [201:297]))
names (dat) <- c ('years','woodm0','woodm1','woodm2')
fit0 <- lm (woodm0 ~ years, data = dat)
fit1 <- lm (woodm1 ~ years, data = dat)
fit2 <- lm (woodm2 ~ years, data = dat)
summary (fit0)
summary (fit1)
summary (fit2)

par (mfrow = c (2, 2))
plot (fit0)
plot (fit1)
plot (fit2)

par (mfrow = c (1, 1))
plot (residuals (fit0), typ = 'b'); abline (h = 0)
plot (residuals (fit1), typ = 'b'); abline (h = 0)
plot (residuals (fit2), typ = 'b'); abline (h = 0)

par (mfrow = c (3, 1))
acf (residuals (fit0))
acf (residuals (fit1))
acf (residuals (fit2))

library ('nlme')

fit0.ac <- gls (woodm0 ~ years, data = dat, correlation = corAR1 (form =~years), na.action = na.omit)
summary (fit0.ac)


# 1996 plots
par (mfrow = c (2, 1))
plot (x    = netpsnMo1 [3553:3564], 
      typ  = 'l',
      col  = 'darkgreen',
      xaxt = 'n',
      xlab = 'month',
      ylab = 'Net carbon assimilation')
axis (1, labels = months, at = 1:12)
lines (folgrespMo1 [3554:3564])
lines (woodgrespMo1 [3554:3564], lty = 2)
lines (woodmrespMo1 [3554:3564], lty = 3)