function [O3]=useO3(clim,ramp)
%
% O3=useO3(clim,ramp)
%
% If "ramp" = 1 O3 will scale linearly between firstyear to 2000 then remain constant.
% To add to the climate input structure:
%
% climIn.O3=O3;
%

% Present day O3
currentO3 = 16;


% Initialize
stYr=clim.year(1);
endYr=clim.year(length(clim.year));
O3=zeros(length(clim.year),1);
yrO3=zeros(12,1);
m=1/(2000-stYr);
b=1-(m*2000);

% Ramp ozone
if ramp	

  for yr=stYr:endYr

    yrIdx=find(clim.year == yr);

    % Concentration scaled
    if yr>=2000
      O3(yrIdx)=currentO3;
    else
      frac=(yr*m)+b;
      O3(yrIdx)=currentO3*frac;
    end
  end

% Or constant concentration over time
else
  for yr=stYr:endYr
    yrIdx=find(clim.year == yr);
    O3(yrIdx)=currentO3;
  end
end
