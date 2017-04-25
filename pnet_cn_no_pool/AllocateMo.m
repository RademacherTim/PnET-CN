function AllocateMo
%
% Monthly C allocation for the PnET ecosystem model.
%


global veg site clim share rstep CN_Mode;


share.PlantC      = share.PlantC      + share.NetPsnMo - share.FolGRespMo;
WoodMRespMo       = share.CanopyGrossPsnActMo * veg.WoodMRespA;
share.WoodMRespYr = share.WoodMRespYr + WoodMRespMo;
share.FolProdCYr  = share.FolProdCYr  + share.FolProdCMo;
share.FolGRespYr  = share.FolGRespYr  + share.FolGRespMo;

% Check if it is wood growth season and grow some wood
if share.GDDTot >= veg.GDDWoodStart
  GDDWoodEff = (share.GDDTot - veg.GDDWoodStart) / (veg.GDDWoodEnd - veg.GDDWoodStart);
  GDDWoodEff = max(0, min(1.0, GDDWoodEff));
  delGDDWoodEff = GDDWoodEff - share.OldGDDWoodEff;
  share.WoodProdCMo = share.WoodC * delGDDWoodEff;
  WoodGRespMo = share.WoodProdCMo * veg.GRespFrac;
  share.WoodProdCYr = share.WoodProdCYr + share.WoodProdCMo;
  share.WoodGRespYr = share.WoodGRespYr + WoodGRespMo;
  share.OldGDDWoodEff = GDDWoodEff;
else
  share.WoodProdCMo = 0;
  WoodGRespMo = 0;
end

TMult = (exp(0.1 * (share.Tave - 7.1)) * 0.68) * 1.0;
RootCAdd = veg.RootAllocA * (share.dayspan(rstep) / 365.0) + veg.RootAllocB * share.FolProdCMo;
share.RootC = share.RootC + RootCAdd;
RootAllocCMo = min(1.0, ((1.0/12.0) * TMult)) * share.RootC;
share.RootC = share.RootC - RootAllocCMo;
RootProdCMo = RootAllocCMo / (1.0 + veg.RootMRespFrac + veg.GRespFrac);
share.RootProdCYr = share.RootProdCYr + RootProdCMo;
RootMRespMo = RootProdCMo * veg.RootMRespFrac;
share.RootMRespYr = share.RootMRespYr + RootMRespMo;
RootGRespMo = RootProdCMo * veg.GRespFrac;
share.RootGRespYr = share.RootGRespYr + RootGRespMo;
share.PlantC = share.PlantC - RootCAdd - WoodMRespMo - WoodGRespMo;
share.NetCBal = share.NetPsnMo - share.SoilRespMo - WoodMRespMo - WoodGRespMo - share.FolGRespMo;

% PnET-CN Only -----------------------------------------------------------------
if CN_Mode==1
  share.WoodMass = share.WoodMass + (share.WoodProdCMo / veg.CFracBiomass);
  share.WoodMassN = share.WoodMassN + ((share.WoodProdCMo / veg.CFracBiomass) * veg.WLPctN * share.NRatio);
  share.PlantN = share.PlantN - ((share.WoodProdCMo / veg.CFracBiomass) * veg.WLPctN * share.NRatio);
  share.RootMass = share.RootMass + (RootProdCMo / veg.CFracBiomass);
  share.RootMassN = share.RootMassN + ((RootProdCMo / veg.CFracBiomass) * veg.RLPctN * share.NRatio);
  share.PlantN = share.PlantN - ((RootProdCMo / veg.CFracBiomass) * veg.RLPctN * share.NRatio);
%  share.NetCBal = share.NetPsnMo - share.SoilDecResp - share.WoodDecResp - WoodMRespMo - WoodGRespMo - share.FolGRespMo - RootMRespMo - RootGRespMo; 
  share.NetCBal = share.NetPsnMo - WoodMRespMo - WoodGRespMo - share.FolGRespMo - RootMRespMo - RootGRespMo; 
end
% ------------------------------------------------------------------------------
