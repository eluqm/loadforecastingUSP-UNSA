
%% four_vs_connectivity = matrix of rows C mean prob RMSE < C,colums = connectivity eg, 0.1:001:0.9  
function plotProbabilities(four_vs_connectivity,legends)
CM={'b','r','g','K',[.5 .6 .7],[.8 .2 .6],[.5 .6 .7],[.8 .2 .6]};
figure('Units', 'pixels', ...
    'Position', [100 100 500 375]);
hold on;
hFit_array=[];
legendInfo = [];
%hFit1   = line(0.1:0.01:0.9,four_vs_connectivity(1,:));
%hFit2  = line(0.1:0.01:0.9,four_vs_connectivity(2,:));
%hFit3   = line(0.1:0.01:0.9,four_vs_connectivity(3,:));
%hFit4   = line(0.1:0.01:0.9,four_vs_connectivity(4,:));
for ii=1:size(four_vs_connectivity,1)
    hFit_array(ii,1)=line(0.1:0.01:0.9,four_vs_connectivity(ii,:));
    set(hFit_array(ii,1)                        , ...
    'LineStyle'       , '-'        , ...
    'Color'           , CM{ii}     , ...        
    'LineWidth'       , 0.5);
    legendInfo{ii}=[                 ...
        strcat('P=',num2str(legends(1,ii)),'x \it{10}^-1')];
end
%hE     = errorbar(xdata_m, ydata_m, ydata_s);
hLegend =legend(legendInfo,'Location','NorthWest');
hTitle  = title ({'Matriz Esparsa de pesos', 'en series temporales hidrólogicas'});
hXLabel = xlabel('Conectividad'              );
hYLabel = ylabel('Probabilidad de RMSE < P'     );
%hLegend = legend( ...
%  [hE, hFit, hData, hModel, hCI(1)], ...
%  'Data (\mu \pm \sigma)' , ...
%  'Fit (\it{C x^3})'      , ...
%  'Validation Data'       , ...
%  'Model (\it{C x^3})'    , ...
%  '95% CI'                , ...
%  'location', 'NorthWest' );
set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hTitle, hXLabel, hYLabel], ...
    'FontName'   , 'Latin Modern Roman');
set([hLegend, gca]             , ...
    'FontSize'   , 8           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 10          , ...
    'FontWeight' , 'bold'      );
set( hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         );


end