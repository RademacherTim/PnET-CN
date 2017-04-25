function [out]=pnetcn(climIn,siteIn,vegIn)
%
% [out]=pnetcn(climIn,siteIn,vegIn)
%

%% Initialize
clear global;

% Vegetation and site constants
global veg;     % Vegetation parameters (input)
global site;    % Site specific parameters (input)
global clim;    % Climatological time series (input)
global share;   % Internal variables shared between functions
global out;     % Calculated variables intended to be returned to the user
global rstep;   % The current running timestep of the execution (day or month)
global ystep;   % The yearstep (only used in constructing the output array)
global CN_Mode; % 1 if running PnET-CN

% Assign input structures to those used within the model
veg = vegIn;  site = siteIn;  clim = climIn;

% Initialize variables
initvars;
CN_Mode  = 1;
%CN_Mode = 0; % pnet-ii

%% Main run loop
% Loop through all climate records
for rstep = 1:length (clim.doy)

 %   veg.FolNCon = 1.8;
 %   share.BudC = 138.0;

  % End-of-year activity
  if (rstep ~= 1) && (clim.doy (rstep) < clim.doy (rstep - 1))
    AllocateYr;
    storeoutput (1);
    YearInit;
  end

  % Call subroutines
  AtmEnviron;
  Phenology (1);
  Photosyn;
  Waterbal;
%  SoilResp;   % pnet-ii
  AllocateMo;
  Phenology (2);
  CNTrans;      %commented for pnet-ii
  Decomp;       %commented for pnet-ii
  Leach;        %commented for pnet-ii
  storeoutput (0);

  
end

% Calculate final year
AllocateYr;
storeoutput(1);
