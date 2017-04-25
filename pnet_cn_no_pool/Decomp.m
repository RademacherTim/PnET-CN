function Decomp
%
% PnET-CN decomposition routine
%


global veg site clim share rstep;

% Add atmospheric N deposition
share.NO3 = share.NO3 + clim.NO3dep(rstep);
share.NH4 = share.NH4 + clim.NH4dep(rstep);
share.NdepTot = share.NdepTot + clim.NO3dep(rstep)+clim.NH4dep(rstep);  




% Temperature effect on all soil processes
tEffSoil = max(share.Tave, 1);
TMult = (exp(0.1 * (share.Tave - 7.1)) * 0.68) * 1;
WMult = share.MeanSoilMoistEff;

% Add litter to Humus pool
share.HOM = share.HOM + share.TotalLitterM;
share.HON = share.HON + share.TotalLitterN;

% Humus dynamics
KhoAct = veg.Kho * (share.dayspan(rstep) / 365);
DHO = share.HOM * (1 - exp(-KhoAct * TMult * WMult));
GrossNMin = DHO * (share.HON / share.HOM);
share.SoilDecResp = DHO * veg.CFracBiomass;
share.SoilDecRespYr = share.SoilDecRespYr + share.SoilDecResp;
share.GrossNMinYr = share.GrossNMinYr + GrossNMin;
share.HON = share.HON - GrossNMin;
share.HOM = share.HOM - DHO;

share.NetCBal = share.NetCBal - share.SoilDecResp; % updating NetCBal 

% Immobilization and net mineralization
SoilPctN = (share.HON / share.HOM) * 100;
NReten = (veg.NImmobA + veg.NImmobB * SoilPctN) / 100;
GrossNImmob = NReten * GrossNMin;
share.HON = share.HON + GrossNImmob;
share.GrossNImmobYr = share.GrossNImmobYr + GrossNImmob;
NetNMin = GrossNMin - GrossNImmob;

share.NH4 = share.NH4 + NetNMin;
NetNitr = (share.NH4 * share.NRatioNit);
share.NO3 = share.NO3 + NetNitr;
share.NH4 = share.NH4 - NetNitr;

% Plant Uptake
RootNSinkStr = (min((share.RootNSinkEff * TMult), 0.98));
PlantNUptake = (share.NH4 + share.NO3) * RootNSinkStr;
if (PlantNUptake + share.PlantN) > veg.MaxNStore
  PlantNUptake = veg.MaxNStore - share.PlantN;
  RootNSinkStr = PlantNUptake / (share.NO3 + share.NH4);
end
if PlantNUptake < 0
  PlantNUptake = 0;
  RootNSinkStr = 0;
end
share.PlantN = share.PlantN + PlantNUptake;
share.PlantNUptakeYr = share.PlantNUptakeYr + PlantNUptake;
 
NH4Up = share.NH4 * RootNSinkStr;
share.NH4 = share.NH4 - NH4Up;
NO3Up = share.NO3 * RootNSinkStr;
share.NO3 = share.NO3 - NO3Up;
 
share.NetNMinYr = share.NetNMinYr + NetNMin;
share.NetNitrYr = share.NetNitrYr + NetNitr;
