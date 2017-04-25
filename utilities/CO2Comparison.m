% Sample script for running the model and comparing CO2 effects

%clear

load hfsite
load nhwd
load hf_1000y_avg 

%vegIn.MinWoodFolRatio=0;

out=pnetcn(climAvg,siteIn,vegIn);

climAvg.CO2=UseMonaLoaCO2(climAvg);
out_co2ramp=pnetcn(climAvg,siteIn,vegIn);

figure
plot(out.nppfol,'r')
hold
plot(out_co2ramp.nppfol)
title('Foliar NPP');
hold

figure
plot(out.nppwood,'r')
hold
plot(out_co2ramp.nppwood)
title('Wood NPP');
hold

figure
plot(out.npproot,'r')
hold
plot(out_co2ramp.npproot)
title('Root NPP');
hold

npptot=out.npproot+out.nppwood+out.nppfol;
npptot_co2ramp=out_co2ramp.npproot+out_co2ramp.nppwood+out_co2ramp.nppfol;

figure
plot(npptot,'r')
hold
plot(npptot_co2ramp)
title('Total NPP');
hold
