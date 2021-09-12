function save_close_figures(save_path) 
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for i=length(FigList):-1:1
    fig = FigList(i);
    %set(fig, 'color', 'w', 'WindowState', 'maximized');
    img = getframe(fig);
    if strcmp(fig.Name, '')
        saveas(fig, fullfile(strcat(save_path,num2str(i))), 'svg');
        %imwrite(img.cdata, fullfile(strcat(save_path,num2str(i), '.png')));
    else
        saveas(fig, fullfile(strcat(save_path,'_',fig.Name)), 'svg');
        %imwrite(img.cdata, fullfile(strcat(save_path,'_',fig.Name, '.png')));
    end        
end
close all;
end