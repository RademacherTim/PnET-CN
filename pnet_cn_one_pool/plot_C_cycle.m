load ('/Users/trademacher/Downloads/PnET_M2.2/samplefiles/vegIn.mat')
load ('/Users/trademacher/Downloads/PnET_M2.2/samplefiles/hfsite.mat')
%load ('/Users/trademacher/Downloads/PnET_M2.2/samplefiles/hf_1000y_avg.mat')
load ('/Users/trademacher/Downloads/PnET_M2.2/samplefiles/hf_300y.mat')
%load ('/Users/trademacher/Downloads/PnET_M2.2/samplefiles/hf_daily.mat')

out=pnetcn(climIn,siteIn,vegIn)

plot (1901:2017, out.plantc (401:517), 'Color', [0.1, 0.9, 0.2], ...
      1901:2017, out.woodc  (401:517), 'Color', [0.5, 0.2, 0.3])

% Plot annual C cycle
plot (1900:1996, out.plantc (201:297), 'Color', [0.1, 0.8, 0.2])
hold on
plot (1900:1996, out.woodc  (201:297), 'Color', [0.7, 0.4, 0.5])
plot (1900:1996, out.budc   (201:297), 'Color', [0.1, 0.6, 0.6])
plot (1900:1996, out.rootc  (201:297), 'Color', [0.9, 0.5, 0.9])
xlabel ('year')
ylabel ('carbon')
hold off

% Plot monthly C cycle
plot (out.plantcMo (2413:3564) + ...
      out.budcMo   (2413:3564) + ...
      out.woodcMo  (2413:3564))

% vegIn parameters according to Zaixing Zhou:
%   - AmaxA is 5.3 for pine and -46 for red maple and oak
%   - AmaxB is 21.5 for pine and 71.9 for red maple and oak
