function [NH4,NO3]=useNDep(clim,ramp)
%
% [NH4,NO3]=useNDep(clim,ramp)
%
% If "ramp" = 1 NDep will scale linearly between firstyear to 2000 then remain constant.
% To add to the climate input structure:
%
% climIn.NO3=NO3;
% climIn.NH4=NH4;
%

% Mean annual atmospheric N deposition values:
% wet deposition (mgN l-1)
avgWetNO3 = .29;
avgWetNH4 = .13;
% dry depsition (gN m-2 year-1)
avgDryNO3 = .204;
avgDryNH4 = .05;


% Initialize
stYr=clim.year(1);
endYr=clim.year(length(clim.year));
NO3=zeros(length(clim.year),1);
NH4=zeros(length(clim.year),1);
wetNO3=zeros(12,1);
wetNH4=zeros(12,1);
dryNO3=zeros(12,1);
dryNH4=zeros(12,1);
m=1/(2000-stYr);
b=1-(m*2000);

% Ramp deposition
if ramp	

  for yr=stYr:endYr

    yrIdx=find(clim.year == yr);

    % total n dep scaled
    if yr>=2000
      % calculate monthly values
      wetNO3(:)=clim.prec(yrIdx)*avgWetNO3;
      wetNH4(:)=clim.prec(yrIdx)*avgWetNH4;
      dryNO3(:)=dryNO3/12;
      dryNH4(:)=dryNH4/12;
      % total
      NO3(yrIdx)=wetNO3+dryNO3;
      NH4(yrIdx)=wetNH4+dryNH4;
    else
      frac=(yr*m)+b;
      % calculate monthly values
      wetNO3(:)=clim.prec(yrIdx)*(frac*avgWetNO3);
      wetNH4(:)=clim.prec(yrIdx)*(frac*avgWetNH4);
      dryNO3(:)=(frac*dryNO3)/12;
      dryNH4(:)=(frac*dryNH4)/12;
      % total      
      NO3(yrIdx)=wetNO3+dryNO3;
      NH4(yrIdx)=wetNH4+dryNH4;
    end
  end

% Or constant deposition over time
else
  for yr=stYr:endYr

    yrIdx=find(clim.year == yr);

    % calculate monthly values
    wetNO3(:)=clim.prec(yrIdx)*avgWetNO3;
    wetNH4(:)=clim.prec(yrIdx)*avgWetNH4;
    dryNO3(:)=dryNO3/12;
    dryNH4(:)=dryNH4/12;

    % total n dep
    NO3(yrIdx)=wetNO3+dryNO3;
    NH4(yrIdx)=wetNH4+dryNH4;
  end
end
