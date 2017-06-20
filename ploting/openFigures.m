%% open fig matlab and show it, in order to save in pdf format 
%% lst_array is array of secuential sufix
function openFigures(prefix,lst_array)
    for i=1:size(lst_array,2)
        %figure('Name',num2str(lst_array(1,i)));
        
        h=openfig(strcat(prefix,num2str(lst_array(1,i)),'.fig'),'visible');
        set(h,'Name',num2str(lst_array(1,i)));
        h=findobj(gca,'Type','Surface');
        Z=get(h(1),'ZData');
        pcolor(Z);
        set(gcf,'Renderer','opengl');
        %print('-dpdf', '-r200', strcat(prefix,num2str(lst_array(1,i)),'.pdf'))
        
        
        %hold on;
        %hold off;
    end

end