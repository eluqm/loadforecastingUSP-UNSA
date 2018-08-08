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
             ax=Root_H;
            outerpos = ax.OuterPosition;
            ti = ax.TightInset; 
            left = outerpos(1) + ti(1);
            bottom = outerpos(2) + ti(2);
            ax_width = outerpos(3) - ti(1) - ti(3);
            ax_height = outerpos(4) - ti(2) - ti(4);
            ax.Position = [left bottom ax_width ax_height];
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            fig_pos = fig.PaperPosition;
            fig.PaperSize = [fig_pos(3) fig_pos(4)];
