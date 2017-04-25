function AllocateYr
%
% Annual C allocation for the PnET ecosystem model.
%


global veg site clim share rstep CN_Mode;

share.NPPFolYr = share.FolProdCYr / veg.CFracBiomass;
share.NPPWoodYr = share.WoodProdCYr / veg.CFracBiomass;
share.NPPRootYr = share.RootProdCYr / veg.CFracBiomass;

if share.DwaterIx > 0
  AvgDWater = share.Dwatertot / share.DwaterIx;
else
  AvgDWater = 1.0;
end

if share.PosCBalMassIx > 0
  avgPCBM = (share.PosCBalMassTot / share.PosCBalMassIx);
else
  avgPCBM = share.FolMass;
end

EnvMaxFol = (AvgDWater * avgPCBM) * (1.0 + (veg.FolRelGrowMax * share.LightEffMin));
SppMaxFol = avgPCBM * (1.0 + (veg.FolRelGrowMax * share.LightEffMin));
veg.FolMassMax = min(EnvMaxFol, SppMaxFol);

% Check for a disturbance year
FolRegen=100;
BiomLossFrac=0;
for i=1:length(site.distyear)
  if clim.year(rstep)==site.distyear(i)
    BiomLossFrac = site.distintensity(i);
    veg.FolMassMax = max(veg.FolMassMax * (1 - BiomLossFrac), FolRegen);  
    break
  end
end

veg.FolMassMin =  (veg.FolMassMax - veg.FolMassMax * (1.0 / veg.FolReten));
share.BudC     = ((veg.FolMassMax - share.FolMass) * veg.CFracBiomass);
  
if share.BudC < 0
  share.BudC = 0;
end

share.PlantCfast = share.PlantCfast - share.BudC;                    % TTR
share.WoodC      = (1.0 - veg.PlantCReserveFrac) * share.PlantCfast; % TTR
share.PlantCfast = share.PlantCfast - share.WoodC;                   % TTR

% Calculate total NSC carbon left
share.PlantC = share.PlantCfast + share.PlantCslow

if share.WoodC < (veg.MinWoodFolRatio * share.BudC)
  TotalC = share.WoodC + share.BudC;
  share.WoodC = TotalC * (veg.MinWoodFolRatio / (1.0 + veg.MinWoodFolRatio));
  share.BudC = TotalC - share.WoodC;
  veg.FolMassMax = share.FolMass + (share.BudC / veg.CFracBiomass);
  veg.FolMassMin = (veg.FolMassMax - veg.FolMassMax * (1.0 / veg.FolReten));
end

% NEP calculation for PnET-II
share.NEP = share.TotPsn - share.WoodMRespYr - share.WoodGRespYr - share.FolGRespYr - share.SoilRespYr;
% save current foliar N for output
share.FolNConOld = veg.FolNCon;

% PnET-CN Only -----------------------------------------------------------------
if CN_Mode==1
  if share.PlantN > veg.MaxNStore
    share.PlantN = veg.MaxNStore;
    share.NH4 = share.NH4 + (share.PlantN - veg.MaxNStore);
  end

  share.NRatio = 1 + (share.PlantN / veg.MaxNStore) * veg.FolNConRange;

  if share.NRatio < 1
    share.NRatio = 1;
  end

  if share.NRatio > (1 + veg.FolNConRange)
    share.NRatio = 1 + veg.FolNConRange;
  end

  share.BudN = (share.BudC / veg.CFracBiomass) * veg.FLPctN * (1 / (1-veg.FolNRetrans)) * share.NRatio;

  if share.BudN > share.PlantN
    if share.PlantN < 0
      share.BudC = share.BudC * 0.1;
      share.BudN = share.BudN * 0.1;
    else
      share.BudC = share.BudC * (share.PlantN / share.BudN);
      share.BudN = share.BudN * (share.PlantN / share.BudN);
    end
  end

%  FolNConOld = veg.FolNCon;
  folnconnew = (share.FolMass * (veg.FolNCon / 100) + share.BudN) / (share.FolMass + (share.BudC / veg.CFracBiomass)) * 100;
  veg.FolNCon = folnconnew;
  
  share.PlantN = share.PlantN - share.BudN;
  
  if share.NRatio < 1
    share.NRatioNit = 0;
  else
    nr              = max ((share.NRatio - 1 - (veg.FolNConRange / 3)), 0);
    share.NRatioNit = min (power ((nr / (0.6667 * veg.FolNConRange)),2),1);
  end

  if share.PlantN > veg.MaxNStore
    share.NH4    = share.NH4 + (share.PlantN - veg.MaxNStore);
    share.PlantN = veg.MaxNStore;
  end

  share.RootNSinkEff = sqrt(1 - (share.PlantN / veg.MaxNStore));

  % Annual total variables for PnET-CN
  share.NEP = share.TotPsn - share.SoilDecRespYr - share.WoodDecRespYr - share.WoodMRespYr - share.WoodGRespYr - share.FolGRespYr - share.RootMRespYr - share.RootGRespYr;
  share.FolN = (share.FolMass * veg.FolNCon / 100);
  share.FolC = share.FolMass * veg.CFracBiomass;
  share.TotalN = share.FolN + share.WoodMassN + share.RootMassN + share.HON + share.NH4 + share.NO3 + share.BudN + share.DeadWoodN + share.PlantN;
  share.TotalM = (share.BudC / veg.CFracBiomass) + share.FolMass + (share.WoodMass + share.WoodC / veg.CFracBiomass) + share.RootMass + share.DeadWoodM + share.HOM + (share.PlantC / veg.CFracBiomass)+(share.RootC / veg.CFracBiomass); % zzx added rootc

end
% ------------------------------------------------------------------------------
