#==============================================================================#
# Plot climate forcing
#------------------------------------------------------------------------------#

# Matlab library
#------------------------------------------------------------------------------#
library (R.matlab)

# Read cliamte data
#------------------------------------------------------------------------------#
HF_arch_daily_1964_2002   <- read.csv ('climIn/hf000-01-daily-m.csv') 
HF_arch_monthly_2002_2017 <- read.csv ('climIn/hf001-04-monthly-m.csv') 
HF_monthly_300y           <- readMat  ('climIn/hf_300y.mat')
HF_monthly_1000y          <- readMat  ('climIn/hf_1000y_avg.mat')
HF_daily                  <- readMat  ('climIn/hf_daily.mat')

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