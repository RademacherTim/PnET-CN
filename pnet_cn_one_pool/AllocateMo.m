function AllocateMo
%
% Monthly C allocation for the PnET ecosystem model.
%


global veg site clim share rstep CN_Mode;

% Update plant C pool
if (site.POOLS == 0) || (site.POOLS == 1)                     % TTR
  share.PlantC      = share.PlantC    + share.NetPsnMo - ...  
                      share.FolGRespMo;
elseif site.POOLS == 2                                        % TTR
  share.PlantCfast = share.PlantCfast + share.NetPsnMo - ...  % TTR
                     share.FolGRespMo;                        % TTR
end                                                           % TTR
share.WoodMRespMo = share.CanopyGrossPsnActMo * veg.WoodMRespA;
share.WoodMRespYr = share.WoodMRespYr + share.WoodMRespMo;
share.FolProdCYr  = share.FolProdCYr  + share.FolProdCMo;
share.FolGRespYr  = share.FolGRespYr  + share.FolGRespMo;

% Determine wood growth
if share.GDDTot >= veg.GDDWoodStart
  GDDWoodEff          = (share.GDDTot - veg.GDDWoodStart) / ...
                        (veg.GDDWoodEnd - veg.GDDWoodStart);
  GDDWoodEff          = max(0, min(1.0, GDDWoodEff));
  delGDDWoodEff       = GDDWoodEff - share.OldGDDWoodEff;
  share.WoodProdCMo   = share.WoodC       * delGDDWoodEff;
  share.WoodGRespMo   = share.WoodProdCMo * veg.GRespFrac;
  share.WoodProdCYr   = share.WoodProdCYr + share.WoodProdCMo;
  share.WoodGRespYr   = share.WoodGRespYr + share.WoodGRespMo;
  share.OldGDDWoodEff = GDDWoodEff;
else
  share.WoodProdCMo = 0;
  share.WoodGRespMo = 0;
end

% Determine root growth
TMult          = (exp(0.1 * (share.Tave - 7.1)) * 0.68) * 1.0;
share.RootCAdd = veg.RootAllocA * (share.dayspan (rstep) / 365.0) + ...
                 veg.RootAllocB * share.FolProdCMo;
share.RootC    = share.RootC + share.RootCAdd;
RootAllocCMo   = min (1.0, ((1.0/12.0) * TMult)) * share.RootC;
share.RootC    = share.RootC - RootAllocCMo;

RootProdCMo    = RootAllocCMo / (1.0 + veg.RootMRespFrac + veg.GRespFrac);
RootMRespMo       = RootProdCMo * veg.RootMRespFrac;
RootGRespMo       = RootProdCMo * veg.GRespFrac;

share.RootProdCYr = share.RootProdCYr + RootProdCMo;
share.RootMRespYr = share.RootMRespYr + RootMRespMo;
share.RootGRespYr = share.RootGRespYr + RootGRespMo;


% Update NSC pool and Net carbon Balance                        % TTR
if (site.POOLS == 0) || (site.POOLS == 1)                       % TTR
  share.PlantC     = share.PlantC      - share.RootCAdd - ...   % TTR
                     share.WoodMRespMo - share.WoodGRespMo;     % TTR
elseif site.POOLS == 2                                          % TTR
  share.PlantCFast = share.PlantCFast  - share.RootCAdd - ...   % TTR
                     share.WoodMRespMo - WoodGRespMo;           % TTR
                 
  % Transport between fast and slow storage                     % TTR
  CTransfer = (share.PlantCSlow - share.PlantCFast) * share.PlantC_tau;
  % CTransfer is positive if slow is larger than fast, which cause a flow
  % from slow to fast

  % Update slow and fast pool sizes                             % TTR
  share.PlantCFast = share.PlantCFast + CTransfer;              % TTR
  share.PlantCSlow = share.PlantCSlow - CTransfer;              % TTR

  % Sum pool sizes to get total NSC carbon                      % TTR
  share.PlantC = share.PlantCFast + share.PlantCSlow;           % TTR
end                                                             % TTR
share.NetCBal = share.NetPsnMo - share.SoilRespMo - share.WoodMRespMo - ...
                share.WoodGRespMo - share.FolGRespMo;

% PnET-CN Only -----------------------------------------------------------------
if CN_Mode == 1
  share.WoodMass  = share.WoodMass + (share.WoodProdCMo / ...
                                      veg.CFracBiomass);
  share.WoodMassN = share.WoodMassN + ((share.WoodProdCMo / ...
                                        veg.CFracBiomass) * ...
                                       veg.WLPctN * share.NRatio);
  share.PlantN    = share.PlantN - ((share.WoodProdCMo / veg.CFracBiomass) ...
                                    * veg.WLPctN * share.NRatio);
  share.RootMass  = share.RootMass + (RootProdCMo / veg.CFracBiomass);
  share.RootMassN = share.RootMassN + ((RootProdCMo / veg.CFracBiomass) ...
                                       * veg.RLPctN * share.NRatio);
  share.PlantN    = share.PlantN - ((RootProdCMo / veg.CFracBiomass) ...
                                    * veg.RLPctN * share.NRatio);
  share.NetCBal   = share.NetPsnMo    - share.WoodMRespMo - ...
                    share.WoodGRespMo - share.FolGRespMo  - ...
                    RootMRespMo       - RootGRespMo; 
end
% ------------------------------------------------------------------------------
