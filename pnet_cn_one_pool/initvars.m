function initvars
%
% Initialize internal shared variable structures for the PnET ecosystem model
%


global veg site clim share rstep ystep;

% Initialise counters
ystep = 1;
rstep = 1;

% Build "share" structure
share.Tave                = 0;
share.Tday                = 0;
share.Tnight              = 0;
share.DayLength           = 0;
share.NightLength         = 0;
share.VPD                 = 0;
share.dayspan             = 0;
share.GDDTot              = 0;
share.OldGDDFolEff        = 0;
share.FolLitM             = 0;
share.PosCBalMass         = 0;
share.PosCBalMassTot      = 0;
share.PosCBalMassIx       = 0;
share.LAI                 = 0;
share.CurrentLAI          = 0; % TTR To get outputs on LAI
share.DVPD                = 0;
share.DayResp             = 0;
share.NightResp           = 0;
share.CanopyNetPsn        = 0;
share.CanopyGrossPsn      = 0;
share.Dwatertot           = 0;
share.DwaterIx            = 0;
share.GrsPsnMo            = 0;
share.NetPsnMo            = 0;
share.FolGRespMo          = 0;
share.WoodMRespYr         = 0;
share.WoodMRespMo         = 0; % TTR Made it a shared variable to have the output
share.CanopyGrossPsnActMo = 0;
share.FolProdCYr          = 0;
share.FolProdCMo          = 0;
share.FolGRespYr          = 0;
share.RootProdCYr         = 0;
share.RootMRespYr         = 0;
share.RootGRespYr         = 0;
share.SoilRespMo          = 0;
share.SoilRespYr          = 0;
share.OldGDDWoodEff       = 0;
share.WoodProdCYr         = 0;
share.WoodGRespYr         = 0;
share.WoodGRespMo         = 0; % TTR Made it a shared variable to have the output
share.WoodProdCMo         = 0; % TTR Made it a shared variable to have the output
share.TotPsn              = 0;
share.MeanSoilMoistEff    = 0;
share.Drainage            = 0;
share.TotDrain            = 0;
share.TotEvap             = 0;
share.TotTrans            = 0;
share.TotPrec             = 0;
share.TotWater            = 0;
share.TotGrossPsn         = 0;
share.NPPFolYr            = 0;
share.NPPWoodYr           = 0;
share.NPPRootYr           = 0;
share.ET                  = 0;
share.NEP                 = 0;
share.NetCBal             = 0;
share.SoilDecResp         = 0;
share.BudN                = 0;
share.SoilDecRespYr       = 0;
share.WoodDecRespYr       = 0;
share.DelAmax             = 0;
share.DWUE                = 0;
share.CanopyDO3Pot        = 0;
share.DroughtO3Frac       = 0;
share.TotO3Dose           = 0;
share.RootMassN           = 0;
share.TotalLitterMYr      = 0;
share.TotalLitterNYr      = 0;
share.GrossNImmobYr       = 0;
share.GrossNMinYr         = 0;
share.PlantNUptakeYr      = 0;
share.NetNitrYr           = 0;
share.NetNMinYr           = 0;
share.FracDrain           = 0;
share.NDrainYr            = 0;
share.WoodDecResp         = 0;
share.TotalLitterM        = 0;
share.TotalLitterN        = 0;
share.FolN                = 0;
share.FolC                = 0;
share.TotalN              = 0;
share.TotalM              = 0;
share.NO3                 = 0;
share.NH4                 = 0;
share.NdepTot             = 0.0; 
share.FolNConOld          = 0.0;

% Shared variables with initial conditions
share.FolMass       = 0;        % share.FolMass=veg.FolMassMin;   In PnET-Day only
share.BudC          = 135;      % share.BudC=(veg.FolMassMax-share.FolMass)*veg.CFracBiomass;  In PnET-Day only
share.Water         = 12;
share.DWater        = 1;
share.DeadWoodM     = 11300;
share.WoodC         = 340;      % TTR Normally 300, adjusted to match two pool implementation
if     site.POOLS == 0          % TTR
  share.PlantC      = 0;        % TTR Originally 900, but here no storage!
elseif site.POOLS == 1          % TTR
  share.PlantC      = 1030;     % TTR Originally 900, changed to fit the two pools initial conditions.   
elseif site.POOLS == 2          % TTR
  share.PlantC      = 1030;     % TTR Should be simplied summed form the two following
  share.PlantC_tau  = 1 / 24.4; % TTR MRT should be 24.4 years to fit Richardson et al. (2013)
end                             % TTR
share.PlantCFast    = 560;      % TTR From Richardson et al. (2013)
share.PlantCSlow    = 470;      % TTR Form Richardson et al. (2013)
share.RootC         = share.WoodC/3;
share.LightEffMin   = 1;
share.NRatio        = 1.3993;
share.PlantN        = 1;
share.WoodMass      = 20000;
share.RootMass      = 6;
share.HOM           = 13500;
share.HON           = 390;
share.RootNSinkEff  = 0.5;
share.WUEO3Eff      = 0;
share.WoodMassN     = share.WoodMass*veg.WLPctN*share.NRatio;
share.DeadWoodN     = share.DeadWoodM*veg.WLPctN*share.NRatio;
share.NRatioNit     = 1.0;
share.NetNMinLastYr = 10;

% Calculate day span (timestep between climate records in days)

%for comparison to pnet-ii & pnet-cn (VB)
for i = 1:length (clim.doy)
  share.dayspan (i) = 30;
end
  
  %for comparison to pnet-ii & pnet-cn (VB)
 for i = 1:50
  share.O3Effect (i) = 0.0;
 end
  
end

%for comparison to pnet-day (VB)
%load ds
%share.dayspan=ds;

%the right way to do it
%share.dayspan(1)=clim.doy(1);
%for i=2:length(clim.doy)
%  if clim.doy(i)<clim.doy(i-1)
%    share.dayspan(i)=clim.doy(i)+(365-clim.doy(i-1));
%  else
%    share.dayspan(i)=clim.doy(i)-clim.doy(i-1);
%  end
%  if share.dayspan(i)==0
%    share.dayspan(i)=1;
%  end
%end
