function  bestPlotTS(Root_H,Title,HXLabel,hYLabel,hLegend)

    
            %% Customise plot labels, titles fonts, etc
            hTitle  = title ({Title});
            hXLabel = xlabel(HXLabel             );
            hYLabel = ylabel(hYLabel     );
            set( Root_H                       , ...
                 'FontName'   , 'Helvetica' );
            set([hTitle, hXLabel, hYLabel], ...
                 'FontName'   , 'Latin Modern Roman');
            set([hLegend, Root_H]             , ...
                 'FontSize'   , 8           );
            set([hXLabel, hYLabel]  , ...
                'FontSize'   , 10          , ...
                'FontWeight' , 'bold'      );
            set( hTitle                    , ...
                'FontSize'   , 12          , ...
                'FontWeight' , 'bold'      );
            set(Root_H, ...
                 'Box'         , 'off'     , ...
                'TickDir'     , 'out'     , ...
                 'TickLength'  , [.02 .02] , ...
                 'XMinorTick'  , 'on'      , ...
                 'YMinorTick'  , 'on'      , ...
                 'YGrid'       , 'on'      , ...
                 'XColor'      , [.3 .3 .3], ...
                 'YColor'      , [.3 .3 .3], ...
                 'LineWidth'   , 1         );


