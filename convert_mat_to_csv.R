header <- c ('GrossPhotosynthesis,Foliage Mass,PlantC,BudC,WoodC,RootC')

# Convert no pool control run
data_alt0_mon <- cbind (as.numeric (unlist(data0$out [1])),  # Grosspsn
                        as.numeric (unlist(data0$out [5])),  # Folm
                        as.numeric (unlist(data0$out [7])),  # PlantC
                        as.numeric (unlist(data0$out [8])),  # BudC
                        as.numeric (unlist(data0$out [9])),  # WoodC
                        as.numeric (unlist(data0$out [10])), # RootC
                        as.numeric (unlist(data0$out [12])), # WoodMResp
                        as.numeric (unlist(data0$out [13])), # WoodGResp
                        as.numeric (unlist(data0$out [14]))) # FolGResp
write.csv (x = data_alt0_mon, file = 'outputs/out_no_pool_monthly.csv')

# Convert one pool control run
data_alt1_mon <- cbind (as.numeric (unlist(data1$out [1])),  # Grosspsn
                        as.numeric (unlist(data1$out [5])),  # Folm
                        as.numeric (unlist(data1$out [7])),  # PlantC
                        as.numeric (unlist(data1$out [8])),  # BudC
                        as.numeric (unlist(data1$out [9])),  # WoodC
                        as.numeric (unlist(data1$out [10])), # RootC
                        as.numeric (unlist(data1$out [12])), # WoodMResp
                        as.numeric (unlist(data1$out [13])), # WoodGResp
                        as.numeric (unlist(data1$out [14]))) # FolGResp
write.csv (x = data_alt1_mon, file = 'outputs/out_one_pool_monthly.csv')

# Convert two pool control run
data_alt2_mon <- cbind (as.numeric (unlist(data2$out [1])),  # Grosspsn
                        as.numeric (unlist(data2$out [5])),  # Folm
                        as.numeric (unlist(data2$out [7])),  # PlantC
                        as.numeric (unlist(data2$out [8])),  # BudC
                        as.numeric (unlist(data2$out [9])),  # WoodC
                        as.numeric (unlist(data2$out [10])), # RootC
                        as.numeric (unlist(data2$out [11])), # WoodMResp
                        as.numeric (unlist(data2$out [12])), # WoodGResp
                        as.numeric (unlist(data2$out [13]))) # FolGResp
write.csv (x = data_alt2_mon, file = 'outputs/out_two_pool_monthly.csv')

# Convert no pool def run
data_alt0.1_mon <- cbind (as.numeric (unlist(data0.1$out [1])),  # Grosspsn
                          as.numeric (unlist(data0.1$out [5])),  # FolM
                          as.numeric (unlist(data0.1$out [7])),  # PlantC
                          as.numeric (unlist(data0.1$out [8])),  # BudC
                          as.numeric (unlist(data0.1$out [9])),  # WoodC
                          as.numeric (unlist(data0.1$out [10])), # RootC
                          as.numeric (unlist(data0.1$out [12])), # WoodMResp
                          as.numeric (unlist(data0.1$out [13])), # WoodGResp
                          as.numeric (unlist(data0.1$out [14]))) # FolGResp
write.csv (x = data_alt0.1_mon, file = 'outputs/out_no_pool_monthly_def.csv')

# Convert one pool def run
data_alt1.1_mon <- cbind (as.numeric (unlist(data1.1$out [1])),
                          as.numeric (unlist(data1.1$out [5])),
                          as.numeric (unlist(data1.1$out [7])),
                          as.numeric (unlist(data1.1$out [8])),
                          as.numeric (unlist(data1.1$out [9])),
                          as.numeric (unlist(data1.1$out [10])), # RootC
                          as.numeric (unlist(data1.1$out [12])), # WoodMResp
                          as.numeric (unlist(data1.1$out [13])), # WoodGResp
                          as.numeric (unlist(data1.1$out [14]))) # FolGResp
write.csv (x = data_alt1.1_mon, file = 'outputs/out_one_pool_monthly_def.csv')

data_alt2.1_mon <- cbind (as.numeric (unlist(data2.1$out [1])),
                          as.numeric (unlist(data2.1$out [5])),
                          as.numeric (unlist(data2.1$out [7])),
                          as.numeric (unlist(data2.1$out [10])),
                          as.numeric (unlist(data2.1$out [11])),
                          as.numeric (unlist(data2.1$out [12])), # RootC
                          as.numeric (unlist(data2.1$out [14])), # WoodMResp
                          as.numeric (unlist(data2.1$out [15])), # WoodGResp
                          as.numeric (unlist(data2.1$out [16]))) # FolGResp
write.csv (x = data_alt2.1_mon, file = 'outputs/out_two_pool_monthly_def.csv')


# Writing annual files
data_alt0 <- cbind (as.numeric (unlist(data0$out [16])), # NNPfol
                    as.numeric (unlist(data0$out [17])), # NPPWood
                    as.numeric (unlist(data0$out [18])), # NPPRoot
                    as.numeric (unlist(data0$out [19])), # NEP 
                    as.numeric (unlist(data0$out [20])), # GPP
                    as.numeric (unlist(data0$out [29])), # PlantC
                    as.numeric (unlist(data0$out [30])), # BudC
                    as.numeric (unlist(data0$out [31])), # WoodC
                    as.numeric (unlist(data0$out [32])), # RootC
                    as.numeric (unlist(data0$out [33])), # Folm
                    as.numeric (unlist(data0$out [35])), # Woodm
                    as.numeric (unlist(data0$out [36])), # Rootm
                    as.numeric (unlist(data0$out [53])), # RMResp
                    as.numeric (unlist(data0$out [54])), # RGResp
                    as.numeric (unlist(data0$out [55]))) # DECResp
write.csv (x = data_alt0, file = 'outputs/out_no_pool_annual.csv')

data_alt1 <- cbind (as.numeric (unlist(data1$out [16])), # NNPfol
                    as.numeric (unlist(data1$out [17])), # NPPWood
                    as.numeric (unlist(data1$out [18])), # NPPRoot
                    as.numeric (unlist(data1$out [19])), # NEP 
                    as.numeric (unlist(data1$out [20])), # GPP
                    as.numeric (unlist(data1$out [29])), # PlantC
                    as.numeric (unlist(data1$out [30])), # BudC
                    as.numeric (unlist(data1$out [31])), # WoodC
                    as.numeric (unlist(data1$out [32])), # RootC
                    as.numeric (unlist(data1$out [33])), # Folm
                    as.numeric (unlist(data1$out [35])), # Woodm
                    as.numeric (unlist(data1$out [36])), # Rootm
                    as.numeric (unlist(data1$out [53])), # RMResp
                    as.numeric (unlist(data1$out [54])), # RGResp
                    as.numeric (unlist(data1$out [55]))) # DECResp
                    write.csv (x = data_alt1, file = 'outputs/out_one_pool_annual.csv')

data_alt2 <- cbind (as.numeric (unlist(data2$out [16])), # NNPfol
                    as.numeric (unlist(data2$out [17])), # NPPWood
                    as.numeric (unlist(data2$out [18])), # NPPRoot
                    as.numeric (unlist(data2$out [19])), # NEP 
                    as.numeric (unlist(data2$out [20])), # GPP
                    as.numeric (unlist(data2$out [29])), # PlantC
                    as.numeric (unlist(data2$out [30])), # BudC
                    as.numeric (unlist(data2$out [31])), # WoodC
                    as.numeric (unlist(data2$out [32])), # RootC
                    as.numeric (unlist(data2$out [33])), # Folm
                    as.numeric (unlist(data2$out [35])), # Woodm
                    as.numeric (unlist(data2$out [36])), # Rootm
                    as.numeric (unlist(data2$out [53])), # RMResp
                    as.numeric (unlist(data2$out [54])), # RGResp
                    as.numeric (unlist(data2$out [55]))) # DECResp
write.csv (x = data_alt2, file = 'outputs/out_two_pool_annual.csv')

# Writing annual files
data_alt0.1 <- cbind (as.numeric (unlist(data0.1$out [16])), # NNPfol
                      as.numeric (unlist(data0.1$out [17])), # NPPWood
                      as.numeric (unlist(data0.1$out [18])), # NPPRoot
                      as.numeric (unlist(data0.1$out [19])), # NEP 
                      as.numeric (unlist(data0.1$out [20])), # GPP
                      as.numeric (unlist(data0.1$out [29])), # PlantC
                      as.numeric (unlist(data0.1$out [30])), # BudC
                      as.numeric (unlist(data0.1$out [31])), # WoodC
                      as.numeric (unlist(data0.1$out [32])), # RootC
                      as.numeric (unlist(data0.1$out [33])), # Folm
                      as.numeric (unlist(data0.1$out [35])), # Woodm
                      as.numeric (unlist(data0.1$out [36])), # Rootm
                      as.numeric (unlist(data0.1$out [53])), # RMResp
                      as.numeric (unlist(data0.1$out [54])), # RGResp
                      as.numeric (unlist(data0.1$out [55]))) # DECResp
write.csv (x = data_alt0.1, file = 'outputs/out_no_pool_annual_def.csv')
                    
data_alt1.1 <- cbind (as.numeric (unlist(data1.1$out [16])), # NNPfol
                      as.numeric (unlist(data1.1$out [17])), # NPPWood
                      as.numeric (unlist(data1.1$out [18])), # NPPRoot
                      as.numeric (unlist(data1.1$out [19])), # NEP 
                      as.numeric (unlist(data1.1$out [20])), # GPP
                      as.numeric (unlist(data1.1$out [29])), # PlantC
                      as.numeric (unlist(data1.1$out [30])), # BudC
                      as.numeric (unlist(data1.1$out [31])), # WoodC
                      as.numeric (unlist(data1.1$out [32])), # RootC
                      as.numeric (unlist(data1.1$out [33])), # Folm
                      as.numeric (unlist(data1.1$out [35])), # Woodm
                      as.numeric (unlist(data1.1$out [36])), # Rootm
                      as.numeric (unlist(data1.1$out [53])), # RMResp
                      as.numeric (unlist(data1.1$out [54])), # RGResp
                      as.numeric (unlist(data1.1$out [55]))) # DECResp
write.csv (x = data_alt1.1, file = 'outputs/out_one_pool_annual_def.csv')
                                        
data_alt2.1 <- cbind (as.numeric (unlist(data2.1$out [16])), # NNPfol
                      as.numeric (unlist(data2.1$out [17])), # NPPWood
                      as.numeric (unlist(data2.1$out [18])), # NPPRoot
                      as.numeric (unlist(data2.1$out [19])), # NEP 
                      as.numeric (unlist(data2.1$out [20])), # GPP
                      as.numeric (unlist(data2.1$out [29])), # PlantC
                      as.numeric (unlist(data2.1$out [30])), # BudC
                      as.numeric (unlist(data2.1$out [31])), # WoodC
                      as.numeric (unlist(data2.1$out [32])), # RootC
                      as.numeric (unlist(data2.1$out [33])), # Folm
                      as.numeric (unlist(data2.1$out [35])), # Woodm
                      as.numeric (unlist(data2.1$out [36])), # Rootm
                      as.numeric (unlist(data2.1$out [53])), # RMResp
                      as.numeric (unlist(data2.1$out [54])), # RGResp
                      as.numeric (unlist(data2.1$out [55]))) # DECResp
write.csv (x = data_alt2.1, file = 'outputs/out_two_pool_annual_def.csv')
