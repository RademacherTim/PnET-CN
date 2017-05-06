function AtmEnviron
%
% Environmental calculations for the PnET ecosystem model.
%


global veg site clim share rstep;


share.Tave = (clim.tmin (rstep) + clim.tmax (rstep)) / 2.0;
share.Tday = (clim.tmax (rstep) + share.Tave) / 2.0;
share.Tnight = (share.Tave + clim.tmin(rstep)) / 2.0;

% Calculate latitude in radians
LatRad = site.Lat * (2.0 * pi) / 360.0;
r = 1 - (0.0167 * cos(0.0172 * (clim.doy (rstep) - 3)));
z = 0.39785  * sin (4.868961 + 0.017203 * clim.doy (rstep) + ...
    0.033446 * sin (6.224111 + 0.017202 * clim.doy (rstep)));

if abs (z) < 0.7
  decl = atan (z / (sqrt (1.0 - power (z, 2))));
else
  decl = pi / 2.0 - atan (sqrt (1.0 - power (z, 2)) / z);
end

if abs (LatRad) >= (pi / 2.0)
  if site.Lat < 0
    LatRad = (-1.0) * (pi / 2.0 - 0.01);
  else
    LatRad = (1.0) * (pi / 2.0 - 0.01);
  end
end

z2 = -tan (decl) * tan (LatRad);

if z2 >= 1.0
  h = 0;
elseif z2 <= -1.0
  h = pi;
else
  TA = abs(z2);
  if TA < 0.7
    AC = 1.570796 - atan (TA / sqrt (1.0 - power (TA, 2)));
  else
    AC = atan (sqrt (1 - power (TA, 2)) / TA);
  end
  if z2 < 0
    h = pi-AC;
  else
    h = AC;
  end
end

% Calcualte day and night length
hr = 2.0 * (h * 24.0) / (2.0 * pi);
share.DayLength = (3600 * hr);
share.NightLength = (3600 * (24.0 - hr));

% Calulate saturation vapour pressure
es = 0.61078 * exp (17.26939 * share.Tday / (share.Tday + 237.3));
delta = 4098.0 * es / ((share.Tday + 237.3)*(share.Tday + 237.3));
if share.Tday < 0
  es = 0.61078 * exp (21.87456 * share.Tday / (share.Tday + 265.5));
  delta = 5808.0 * es / ((share.Tday + 265.5)*(share.Tday + 265.5));
end

emean = 0.61078 * exp(17.26939 * clim.tmin(rstep) / (clim.tmin(rstep) + 237.3));
if clim.tmin(rstep) < 0
  emean = 0.61078 * exp(21.87456 * clim.tmin(rstep) / (clim.tmin(rstep) + 265.5));
end

share.VPD = es - emean;

% Sum growing degree days
GDD = share.Tave * share.dayspan (rstep);
if GDD < 0
  GDD = 0;
end
share.GDDTot = share.GDDTot + GDD;