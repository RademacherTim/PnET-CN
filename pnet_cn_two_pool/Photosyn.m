function Photosyn
%
% Photosynthesis routine for the PnET ecosystem model.
%


global veg site clim share rstep;


PsnTMax = veg.PsnTOpt + (veg.PsnTOpt - veg.PsnTMin);
DTemp = ((PsnTMax - share.Tday) * (share.Tday - veg.PsnTMin)) / (power(((PsnTMax - veg.PsnTMin) / 2.0),2));
if (clim.tmin(rstep) < 6) && (DTemp > 0) && (share.GDDTot >= veg.GDDFolEnd)
  % Frost effect
  DTemp = DTemp * (1.0 - ((6.0 - clim.tmin(rstep)) / 6.0) * (share.dayspan(rstep) / 30.0));
end
DTemp = max(DTemp, 0);
share.DVPD = 1.0 - veg.DVPD1 * (power(share.VPD,veg.DVPD2));
ten9 = 1000000000.0;

% Set atmospheric CO2 concentration
Ca = clim.CO2(rstep);

% CO2 effect on photosynthesis
% Leaf internal/external CO2
CiCaRatio = (-0.075 * veg.FolNCon) + 0.875;
% Ci at present (350 ppm) CO2
Ci350 = 350 * CiCaRatio;
% Ci at RealYear CO2 level
CiElev = Ca * CiCaRatio;
Arel350 = 1.22 * ((Ci350 - 68) / (Ci350 + 136));
ArelElev = 1.22 * ((CiElev - 68) / (CiElev + 136));
share.DelAmax = 1 + ((ArelElev - Arel350) / Arel350);

% Calculate CO2 effect on conductance and set slope and intercept for A-gs relationship
if site.CO2gsEffect==1
  Delgs = share.DelAmax / ((Ca - CiElev) / (350 - Ci350));
  share.DWUE = 1 + (1 - Delgs);
  gsSlope = (-1.1309 * share.DelAmax) + 1.9762;
  gsInt = (0.4656 * share.DelAmax) - 0.9701;
else
  share.DWUE = 1;
  gsSlope = (-0.6157 * share.DelAmax) + 1.4582;
  gsInt = (0.4974 * share.DelAmax) - 0.9893;
end

Amax = (veg.AmaxA + veg.AmaxB * veg.FolNCon) * share.DelAmax;

BaseFolResp = veg.BaseFolRespFrac * Amax;
Amax = Amax * veg.AmaxFrac;
GrossAmax = Amax + BaseFolResp;
GrossAmax = (GrossAmax * share.DVPD * DTemp * share.DayLength * 12.0) / ten9;

if GrossAmax < 0
  GrossAmax = 0;
end
share.DayResp = (BaseFolResp * (power(veg.RespQ10,((share.Tday - veg.PsnTOpt) / 10.0))) * share.DayLength * 12.0) / ten9;
share.NightResp = (BaseFolResp * (power(veg.RespQ10,((share.Tnight - veg.PsnTOpt) / 10.0))) * share.NightLength * 12.0) / ten9;

% Initialize ozone effect
CanopyNetPsnO3 = 0;
CanopyNetPsnPot = 0;

% Calculate canopy ozone extinction based on folmass
O3Prof = 0.6163 + (0.00105 * share.FolMass);

if share.FolMass > 0
  share.CanopyNetPsn = 0;
  share.CanopyGrossPsn = 0;
  share.LAI = 0;
  share.PosCBalMass = share.FolMass;
%  O3Effect = 0;
  Layer = 0;
  
  for ix = 1:50
    i = ix * (share.FolMass / 50.0);
    SLWLayer = veg.SLWmax - (veg.SLWdel * i);
    share.LAI = share.LAI + (share.FolMass / 50.0) / SLWLayer;
    Il = clim.par(rstep) * exp(-veg.k * share.LAI);
    LightEff = (1.0 - exp(-Il * log(2.0) / veg.HalfSat));
    LayerGrossPsnRate = GrossAmax * LightEff;
    LayerGrossPsn = LayerGrossPsnRate * (share.FolMass / 50.0);
    LayerResp = (share.DayResp + share.NightResp) * (share.FolMass / 50.0);
    LayerNetPsn = LayerGrossPsn - LayerResp;
    if (LayerNetPsn < 0) && (share.PosCBalMass == share.FolMass)
      share.PosCBalMass = (ix - 1.0) * (share.FolMass / 50.0);
    end
    share.CanopyNetPsn = share.CanopyNetPsn + LayerNetPsn;
    share.CanopyGrossPsn = share.CanopyGrossPsn + LayerGrossPsn;
    
    % Ozone effects on Net Psn
    if (clim.O3(rstep)>0)
      % Convert netpsn to micromoles for calculating conductance
      netPsnumol = ((LayerNetPsn * 10 ^ 6) / (share.DayLength * 12)) / ((share.FolMass / 50) / SLWLayer);
      % Calculate ozone extinction throughout the canopy
      Layer = Layer + 1;
      RelLayer = Layer / 50;
      RelO3 = 1 - (RelLayer * O3Prof) ^ 3;
      % Calculate Conductance (mm/s): Conductance down-regulates with prior O3 effects on Psn
      LayerG = (gsInt + (gsSlope * netPsnumol)) * (1 - share.O3Effect(Layer));
      % For no downregulation use:    LayerG = gsInt + (gsSlope * netPsnumol);
      if LayerG < 0
        LayerG = 0;
      end
      % Calculate cumulative ozone effect for each canopy layer with consideration that previous O3 effects were modified by drought
      share.O3Effect(Layer) = (share.O3Effect(Layer) * share.DroughtO3Frac) + (0.0026 * LayerG * clim.O3(rstep) * RelO3);
      if (share.O3Effect(Layer)>1)
          share.O3Effect(Layer)=1;
      end
      LayerDO3 = 1 - share.O3Effect(Layer);
    else
      LayerDO3 = 1;
    end

    LayerNetPsnO3 = LayerNetPsn * LayerDO3;
    CanopyNetPsnO3 = CanopyNetPsnO3 + LayerNetPsnO3;
  end

  if (DTemp > 0) && (share.GDDTot > veg.GDDFolEnd) && (clim.doy(rstep) < veg.SenescStart)
    share.PosCBalMassTot = share.PosCBalMassTot + (share.PosCBalMass * share.dayspan(rstep));
    share.PosCBalMassIx = share.PosCBalMassIx + share.dayspan(rstep);
  end  

  if share.LightEffMin > LightEff
    share.LightEffMin = LightEff;
  end
  
else
  share.PosCBalMass = 0;
  share.CanopyNetPsn = 0;
  share.CanopyGrossPsn = 0;
  share.LAI = 0;
  share.DayResp = 0;
  share.NightResp = 0;
end

% Share LAI % TTR
share.CurrentLAI = share.LAI; % TTR

% Calculate whole-canopy ozone effects before drought
if (clim.O3(rstep)>0) && (share.CanopyGrossPsn>0)
  CanopyNetPsnPot = share.CanopyGrossPsn - (share.DayResp * share.FolMass) - (share.NightResp * share.FolMass);
  share.CanopyDO3Pot = CanopyNetPsnO3 / CanopyNetPsnPot;
else
  share.CanopyDO3Pot = 1;
end
