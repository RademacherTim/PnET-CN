% Create a 1000 year average climate file from the HF 300 year data

load hfsite
load nhwd
load hf_300y

climAvg.year=zeros(12000,1);
climAvg.doy=zeros(12000,1);
climAvg.tmax=zeros(12000,1);
climAvg.tmin=zeros(12000,1);
climAvg.par=zeros(12000,1);
climAvg.prec=zeros(12000,1);
climAvg.O3=zeros(12000,1);
climAvg.NH4=zeros(12000,1);
climAvg.NO3=zeros(12000,1);
climAvg.CO2=zeros(12000,1);

doy=reshape(climIn.doy(3564-239:3564),12,20);
tmax=reshape(climIn.tmax(3564-239:3564),12,20);
tmin=reshape(climIn.tmin(3564-239:3564),12,20);
par=reshape(climIn.par(3564-239:3564),12,20);
prec=reshape(climIn.prec(3564-239:3564),12,20);
O3=reshape(climIn.O3(3564-239:3564),12,20);
NH4=reshape(climIn.NH4(3564-239:3564),12,20);
NO3=reshape(climIn.NO3(3564-239:3564),12,20);
CO2=reshape(climIn.CO2(3564-239:3564),12,20);

for m=1:12
  doyA(m)=mean(doy(m,:));
  tmaxA(m)=mean(tmax(m,:));
  tminA(m)=mean(tmin(m,:));
  parA(m)=mean(par(m,:));
  precA(m)=mean(prec(m,:));
  O3A(m)=mean(O3(m,:));
  NH4A(m)=mean(NH4(m,:));
  NO3A(m)=mean(NO3(m,:));
  CO2A(m)=mean(CO2(m,:));
end

for i=1:1000
  climAvg.year((((i-1)*12)+1):(i*12))=i+1500;
  climAvg.doy((((i-1)*12)+1):(i*12))=doyA;
  climAvg.tmax((((i-1)*12)+1):(i*12))=tmaxA;
  climAvg.tmin((((i-1)*12)+1):(i*12))=tminA;
  climAvg.par((((i-1)*12)+1):(i*12))=parA;
  climAvg.prec((((i-1)*12)+1):(i*12))=precA;
  climAvg.O3((((i-1)*12)+1):(i*12))=O3A;
  climAvg.NH4((((i-1)*12)+1):(i*12))=NH4A;
  climAvg.NO3((((i-1)*12)+1):(i*12))=NO3A;
  climAvg.CO2((((i-1)*12)+1):(i*12))=CO2A;
end

save hf_1000y_avg.mat climAvg
