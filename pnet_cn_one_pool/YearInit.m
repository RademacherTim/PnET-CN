function YearInit
%
% Annual initialization for the PnET ecosystem model.
%


global veg site clim share rstep;


share.GDDTot         = 0;
share.WoodMRespYr    = 0;
share.SoilRespYr     = 0;
share.TotTrans       = 0;
share.TotPsn         = 0;
share.TotGrossPsn    = 0;
share.TotDrain       = 0;
share.TotPrec        = 0;
share.TotEvap        = 0;
share.TotWater       = 0;
share.FolProdCYr     = 0;
share.WoodProdCYr    = 0;
share.RootProdCYr    = 0;
share.RootMRespYr    = 0;
share.FolGRespYr     = 0;
share.WoodGRespYr    = 0;
share.RootGRespYr    = 0;
share.OldGDDFolEff   = 0;
share.OldGDDWoodEff  = 0;
share.PosCBalMassTot = 0;
share.PosCBalMassIx  = 0;
share.Dwatertot      = 0;
share.DwaterIx       = 0;
share.NDrainYr       = 0;
share.NetNMinYr      = 0;
share.GrossNMinYr    = 0;
share.PlantNUptakeYr = 0;
share.GrossNImmobYr  = 0;
share.TotalLitterMYr = 0;
share.TotalLitterNYr = 0;
share.NetNitrYr      = 0;
share.LightEffMin    = 1;
share.SoilDecRespYr  = 0;
share.WoodDecRespYr  = 0;
share.NetNMinLastYr  = share.NetNMinYr;
share.NdepTot=0.0; 
for i = 1:50
share.O3Effect (i)   = 0.0;
end