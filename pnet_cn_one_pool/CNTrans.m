function CNTrans
%
% Carbon and nitrogen translocation routine
%


global veg site clim share rstep;

% Check for a disturbance year
BiomLossFrac = 0;
RemoveFrac   = 0;
if clim.doy (rstep) > 335
  for i = 1:length (site.distyear)
    if clim.year (rstep) == site.distyear (i)
      BiomLossFrac = site.distintensity (i);
      RemoveFrac   = site.distremove (i);
      share.HOM    = share.HOM * (1 - site.distsoilloss (i));
      share.HON    = share.HON * (1 - site.distsoilloss (i));
      break
    end
  end
end

% (Partial) defoliation in June 1910                          % TTR
% The C and N are currently lost from the system and not added to the
% litter pool.
if site.DEFOLIATION > 0                                       % TTR
  if clim.year (rstep) == 1910 && clim.doy (rstep) == 166     % TTR
    removal_fraction = site.DEFOLIATION;                      % TTR
    share.FolMass = share.FolMass * (1.0 - removal_fraction); % TTR
  end                                                         % TTR
end                                                           % TTR

RootTurnover = veg.RootTurnoverA - ...
              (veg.RootTurnoverB * share.NetNMinLastYr) + ...
              (veg.RootTurnoverC * power(share.NetNMinLastYr,2));
          
if RootTurnover > 2.5
  RootTurnover = 2.5;
elseif RootTurnover < 0.1
  RootTurnover = 0.1;
end
RootTurnover = RootTurnover * (share.dayspan (rstep) / 365);
if BiomLossFrac > RootTurnover
  RootTurnover = BiomLossFrac;
end
RootLitM = share.RootMass * RootTurnover;
RootLitN = RootLitM * (share.RootMassN / share.RootMass);
share.RootMass  = share.RootMass  - RootLitM;
share.RootMassN = share.RootMassN - RootLitN;

if BiomLossFrac > 0
  WoodLitM = share.WoodMass  * BiomLossFrac * (1 - RemoveFrac);
  WoodLitN = share.WoodMassN * BiomLossFrac * (1 - RemoveFrac);
  share.WoodMass  = share.WoodMass  * (1 - BiomLossFrac);
  share.WoodMassN = share.WoodMassN * (1 - BiomLossFrac);
else
  WoodLitM = share.WoodMass  * veg.WoodTurnover * (share.dayspan(rstep) / 365);
  WoodLitN = share.WoodMassN * veg.WoodTurnover * (share.dayspan(rstep) / 365);
  share.WoodMass  = share.WoodMass  - WoodLitM;
  share.WoodMassN = share.WoodMassN - WoodLitN;
end

share.DeadWoodM = share.DeadWoodM + WoodLitM;
share.DeadWoodN = share.DeadWoodN + WoodLitN;
WoodMassLoss = share.DeadWoodM * veg.WoodLitLossRate * (share.dayspan(rstep) / 365);
WoodTransM = WoodMassLoss * (1 - veg.WoodLitCLoss);
share.WoodDecResp = (WoodMassLoss - WoodTransM) * veg.CFracBiomass;
share.WoodDecRespYr = share.WoodDecRespYr + share.WoodDecResp;
WoodTransN = (WoodMassLoss / share.DeadWoodM) * share.DeadWoodN;
share.DeadWoodM = share.DeadWoodM - WoodMassLoss;
share.DeadWoodN = share.DeadWoodN - WoodTransN;

share.NetCBal = share.NetCBal - share.WoodDecResp;  % updating NetCBal

FolNLoss = share.FolLitM * (veg.FolNCon / 100);
Retrans = FolNLoss * veg.FolNRetrans;
share.PlantN = share.PlantN + Retrans;
FolLitN = FolNLoss - Retrans;

if BiomLossFrac > 0
  share.FolLitM = share.FolLitM + (share.FolMass * BiomLossFrac);
  FolLitN = FolLitN + (share.FolMass * BiomLossFrac * (veg.FolNCon / 100));
  share.FolMass = share.FolMass * (1 - BiomLossFrac);
  share.PlantC  = share.PlantC  * (1 - BiomLossFrac);
  share.PlantN  = share.PlantN  + (veg.MaxNStore - share.PlantN) * BiomLossFrac;
end

share.TotalLitterM = share.FolLitM + RootLitM + WoodTransM;
share.TotalLitterN = FolLitN + RootLitN + WoodTransN;

% Agriculture
if clim.year (rstep) >= site.agstart && clim.year (rstep) < site.agstop
  share.TotalLitterM = share.TotalLitterM * (1 - site.agrem);
  share.TotalLitterN = share.TotalLitterN * (1 - site.agrem);
  share.WoodMass     = share.WoodMass     * (1 - site.agrem * ...
                                            (share.dayspan (rstep) / 365));
  share.WoodMassN    = share.WoodMassN    * (1 - site.agrem * ...
                                            (share.dayspan (rstep) / 365));
end

share.TotalLitterMYr = share.TotalLitterMYr + share.TotalLitterM;
share.TotalLitterNYr = share.TotalLitterNYr + share.TotalLitterN;
