%function pnetexplorer
%
% Shell for running PnET-CN and exploring C, N and H2O cycles
%

clear

%% Load input variables
cd '../samplefiles'
load hf_1000y_avg
load hfsite_noco2
%load hfsite
load nhwd
clim=climAvg;
yrs=700;

l=length(out.trans);
t=1:length(clim.year);

%% Run model
cd '../pnet_cn'
[out]=pnetcn(clim,siteIn,vegIn);

%% Climate variables
figure(1)
subplot(3,2,1)
plot(t,clim.tmin,'b',t,clim.tmax,'r');
title('Temperature');
subplot(3,2,2)
plot(t,clim.prec,'k');
title('Precipitation');
subplot(3,2,3)
plot(t,clim.par,'k');
title('PAR');
subplot(3,2,4)
plot(t,clim.O3,'k');
title('Ozone');
subplot(3,2,5)
plot(t,clim.CO2,'k');
title('CO2');
subplot(3,2,6)
plotyy(t,clim.NH4,t,clim.NO3);
title('NH4 and NO3');


%% Water cycle
% Chop vectors
waterstress=out.waterstress(l-yrs:l);
trans=out.trans(l-yrs:l);
soilwater=out.soilwater(l-yrs:l);
psn=out.psn(l-yrs:l);
drain=out.drain(l-yrs:l);
prec=out.prec(l-yrs:l);
evap=out.evap(l-yrs:l);
et=out.et(l-yrs:l);
% Scale vectors
waterstress=waterstress/(max(waterstress));
trans=trans/(max(trans));
soilwater=soilwater/(max(soilwater));
psn=psn/(max(psn));
drain=drain/(max(drain));
prec=prec/(max(prec));
evap=evap/(max(evap));
et=et/(max(et));
% Plot
figure(2)
hold
plot(waterstress,'k--','DisplayName','Water stress');
plot(trans,'r--','DisplayName','Transpiration');
plot(soilwater,'b','DisplayName','Soil Water');
plot(psn,'g','DisplayName','Photosynthesis');
plot(drain,'c','DisplayName','Drainage');
plot(prec,'k','DisplayName','Precipitation');
plot(evap,'r','DisplayName','Evaporation');
plot(et,'m','DisplayName','Evapotranspiration');
hold
title('Water Cycle')


%% Carbon cycle
% Chop vectors
plantc=out.plantc(l-yrs:l);
budc=out.budc(l-yrs:l);
woodc=out.woodc(l-yrs:l);
rootc=out.rootc(l-yrs:l);
% Scale vectors
plantc=plantc/(max(plantc));
budc=budc/(max(budc));
woodc=woodc/(max(woodc));
rootc=rootc/(max(rootc));
% Plot
figure(3)
hold
plot(plantc,'k','DisplayName','Plant C');
plot(budc,'b','DisplayName','Bud C');
plot(woodc,'r','DisplayName','Wood C');
plot(rootc,'c','DisplayName','Root C');
hold
title('Carbon cycle')



%% Nitrogen cycle
% Chop vectors
plantnYr=out.plantnYr(l-yrs:l);
budn=out.budn(l-yrs:l);
ndrain=out.ndrain(l-yrs:l);
netmin=out.netnmin(l-yrs:l);
grossmin=out.grossnmin(l-yrs:l);
nplantuptake=out.nplantuptake(l-yrs:l);
grossnimob=out.grossnimob(l-yrs:l);
littern=out.littern(l-yrs:l);
netnitrif=out.netnitrif(l-yrs:l);
nratio=out.nratio(l-yrs:l);
foln=out.foln(l-yrs:l);
% Scale vectors
plantnYr=plantnYr/(max(plantnYr));
budn=budn/(max(budn));
ndrain=ndrain/(max(ndrain));
netmin=netmin/(max(netmin));
grossmin=grossmin/(max(grossmin));
nplantuptake=nplantuptake/(max(nplantuptake));
grossnimob=grossnimob/(max(grossnimob));
littern=littern/(max(littern));
netnitrif=netnitrif/(max(netnitrif));
nratio=nratio/(max(nratio));
foln=foln/(max(foln));
% Plot
figure(4)
hold
plot(plantnYr,'k','DisplayName','Plant N');
plot(budn,'k--','DisplayName','Bud N');
plot(ndrain,'b','DisplayName','N Drain');
plot(netmin,'b--','DisplayName','Net Min');
plot(grossmin,'g','DisplayName','Gross Min');
plot(nplantuptake,'g--','DisplayName','N Uptake');
plot(grossnimob,'r','DisplayName','Gross Imob');
plot(littern,'r--','DisplayName','Lit N');
plot(netnitrif,'c','DisplayName','Net Nitr');
plot(nratio,'m','DisplayName','N Ratio');
plot(foln,'y','DisplayName','Fol N');
hold
title('Nitrogen cycle')

%% PnET-CN Paper Comparison
figure(5)
hold
plot(out.nppfol(l-yrs:l),'r','DisplayName','NPP Foliage');
plot(out.nppwood(l-yrs:l),'m','DisplayName','NPP Wood');
plot(out.npproot(l-yrs:l),'k','DisplayName','NPP Root');
hold
title('NPP')
figure(6)
hold
plot(out.netnmin(l-yrs:l),'b--','DisplayName','Net N Min');
plot(out.netnitrif(l-yrs:l),'k','DisplayName','Net Nitr');
plot(out.ndrain(l-yrs:l),'r','DisplayName','N Leaching');
plot(out.foln(l-yrs:l),'g','DisplayName','Fol N Con');
hold
title('N Cycling')














