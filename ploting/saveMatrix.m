function saveMatrix(matrix,name)
%SAVEMATRIX Summary of this function goes here
%   Detailed explanation goes here
figure('Visible','off')
surf([1:1:size(matrix,1)],[1:1:size(matrix,1)],matrix,'EdgeColor','None','facecolor','interp');
view(2)
colorbar;
colormap(winter);
savefig(strcat(name,'.fig'));
set(gcf,'Renderer','opengl');
%% problem!!!! with save high resolution image in pdf
%print(gcf,'-dpdf','-r2000', strcat(name,'.pdf'));
%saveas(gcf,strcat(name,'.pdf'));
%set(gcf,'Renderer','opengl');
hold off;

end

