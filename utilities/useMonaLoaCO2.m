function [Ca]=useMonaLoaCO2(climIn)
%
% Ca=UseMonaLoaCO2(climIn)
%
% To put this new CO2 ramp into the climate input:
%
% climIn.CO2=Ca
%

% Calculate atmospheric CO2 concentration (Ca) lowered to 280 base
for rstep=1:length(climIn.year)
  if climIn.year(rstep)<=1800
    % Background (historical) CO2 level
    Ca(rstep) = 280;
  elseif (climIn.year(rstep)>1800) && (climIn.year(rstep)<=2100)
    % Exponentially ramp up to 600 ppm by 2100
    Ca(rstep) = 280 + (0.0188 * (climIn.year(rstep) - 1800)) ^ 3.35;
  else
    % Use future elevated level
    Ca(rstep) = 600;
  end
end
