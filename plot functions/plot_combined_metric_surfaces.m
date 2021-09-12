function plot_combined_metric_surfaces(output1,output2,point_col1,point_col2)
hold off;
h = heatmap([1,2]);
map = h.Colormap;
close all;

labels = ["p(stay|win)", "p(win)", "ERDS+"; "p(switch|lose)", "p(lose)", "ERDS-";...
    "p(stay|better)", "p(better)", "EODS_B"; "p(switch|worse)", "p(worse)", "EODS_W";...
    "p(stay|win)", "p(switch|lose)", "ERDS"; "p(stay|better)", "p(switch|worse)", "EODS"];
bd_labels = ["winstay", "pwinR", "ERDS_win"; "loseswitch", "ploseR", "ERDS_lose";...
    "betterstay", "pbetterR", "EODS_better"; "worseswitch", "pworseR", "EODS_worse";...
    "winstay", "loseswitch", "ERDS"; "betterstay", "worseswitch", "EODS"];
figure; hold on;
for i=1:4
    %%Surface plots
    if i<3
        subplot(2,3,i+1);
    else
        subplot(2,3,i+2);
    end
    points = linspace(0,1,50);
    [win, WS] = meshgrid(points,points);
    ERDSp = (-win.*WS.*log2(WS)+-win.*(1-WS).*log2(1-WS));
    ERDSp(isnan(ERDSp)) = 0;
    s = surf(WS,win,ERDSp, 'FaceAlpha', 0.5);
    xlabel(labels(i,1));
    ylabel(labels(i,2));
    zlabel(labels(i,3));
    colormap(map);
    s.EdgeAlpha = 0;
    
    hold on;
    overlayed_scatter(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),output1.(bd_labels(i,3)),...
        output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),output2.(bd_labels(i,3)),...
        point_col1, point_col2);
    set(gca, 'XTick', [0:.5:1], 'YTick', [0:.5:1], 'ZTick', [0:.5:1]);
    
    set(gca,'FontName','Helvetica','FontSize',12);
    
    set(gcf,'units','centimeters', 'position',[   -0.5997    0.0176   30.6917   16.9157]);
    set(gca,'LineWidth',2)
    set(gca, 'tickdir', 'out')
    yax = get(gca,'ylabel');
    xax = get(gca,'xlabel');
    
    set(yax, 'rotation', -31);
    set(xax, 'rotation', 17);
    
    xax.Position(2) = xax.Position(2) + .05;
    yax.Position(1) = yax.Position(1) + .04;
    
    yax.Position(2) = yax.Position(2);
    xax.Position(1) = xax.Position(1) -.1+.02-0.08;
end

for i=5:6
    if i==5
        subplot(2,3,1);
    else
        subplot(2,3,4);
    end
    points = linspace(0,1,50);
    [LS, WS] = meshgrid(points,points);
    lose = .5;
    win = 1-lose;
    ERDS = -(WS.*win.*log2(WS)+(1-WS).*win.*log2(1-WS)...
        +LS.*lose.*log2(LS)+(1-LS).*lose.*log2(1-LS));
    s = surf(WS,LS,ERDS, 'FaceAlpha', 0.5);
    xlabel(labels(i,1));
    ylabel(labels(i,2));
    zlabel(labels(i,3));
    colormap(map);
    s.EdgeAlpha = 0;
    hold on;
    overlayed_scatter(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),output1.(bd_labels(i,3)),...
        output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),output2.(bd_labels(i,3)),...
        point_col1, point_col2);
    set(gca, 'XTick', [0:.5:1], 'YTick', [0:.5:1], 'ZTick', [0:.5:1]);
    set(gca,'FontName','Helvetica','FontSize',12);
    set(gca,'LineWidth',2)
    set(gca, 'tickdir', 'out')
    
    yax = get(gca,'ylabel');
    xax = get(gca,'xlabel');
    
    set(yax, 'rotation', -31);
    set(xax, 'rotation', 17);
    
    xax.Position(2) = xax.Position(2) + .05;
    yax.Position(1) = yax.Position(1) + .04;
    
    yax.Position(2) = yax.Position(2) -.15+.02-0.07;
    xax.Position(1) = xax.Position(1) -.1+.02-0.08;
end
figure('Position', [-0.0030    0.1923    1.1987    0.4480]*1000); hold on;
for i=1:4
    %%heatmap plots
    if i<3
        subplot(2,3,i+1);
    else
        subplot(2,3,i+2);
    end
    points = linspace(0,1,50);
    [win, WS] = meshgrid(points,points);
    ERDSp = (-win.*WS.*log2(WS)+-win.*(1-WS).*log2(1-WS));
    ERDSp(isnan(ERDSp)) = 0;
    s = surf(WS,win,ERDSp, 'FaceAlpha', 0.5);
    view(2);
    grid off;
    
    xlabel(labels(i,1));
    ylabel(labels(i,2));
    zlabel(labels(i,3));
    colormap(map);
    b = colorbar('Ticks', [0, 0.5, .98], 'TickLabels', {'0', '0.5', '1'}, 'location', 'westoutside');
    b.Label.String = labels(i,3);
    b.Label.FontSize = 12;
    s.EdgeAlpha = 0;
    
    hold on;
    overlayed_scatter(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),1.1*ones(size(output1.(bd_labels(i,2)),1), size(output1.(bd_labels(i,2)),2)),...
        output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),1.1*ones(size(output2.(bd_labels(i,2)),1), size(output2.(bd_labels(i,2)),2)),...
        point_col1, point_col2, .5);
    
    overlayed_scatter_no_div(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),ones(size(output1.(bd_labels(i,2)),1), size(output1.(bd_labels(i,2)),2)),...
        output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),ones(size(output2.(bd_labels(i,2)),1), size(output2.(bd_labels(i,2)),2)),...
        point_col1, point_col2, .25);
    set(gca, 'XTick', [0:.5:1], 'YTick', [0:.5:1], 'ZTick', [0:.5:1]);
    set(gca,'FontName','Helvetica','FontSize',12);
    set(gca,'LineWidth',2);
    set(gca, 'tickdir', 'out');
    yax = get(gca,'ylabel');
    xax = get(gca,'xlabel');
end

for i=5:6
    if i==5
        subplot(2,3,1);
    else
        subplot(2,3,4);
    end
    points = linspace(0,1,50);
    [LS, WS] = meshgrid(points,points);
    lose = .5;
    win = 1-lose;
    ERDS = -(WS.*win.*log2(WS)+(1-WS).*win.*log2(1-WS)...
        +LS.*lose.*log2(LS)+(1-LS).*lose.*log2(1-LS));
    s = surf(WS,LS,ERDS, 'FaceAlpha', 0.5);
    view(2);
    grid off;
    
    xlabel(labels(i,1));
    ylabel(labels(i,2));
    zlabel(labels(i,3));
    colormap(map);
    b = colorbar('Ticks', [.2, 0.4, .6, .8, .99], 'TickLabels', {'0.2', '0.4', '0.6','0.8', '1'}, 'location', 'westoutside');
    b.Label.String = labels(i,3);
    b.Label.FontSize = 12;
    s.EdgeAlpha = 0;
    hold on;
    overlayed_scatter(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),1.1*ones(size(output1.(bd_labels(i,2)),1), size(output1.(bd_labels(i,2)),2)),...
        output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),1.1*ones(size(output1.(bd_labels(i,2)),1), size(output1.(bd_labels(i,2)),2)),...
        point_col1, point_col2, .5);
    
    overlayed_scatter_no_div(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),ones(size(output1.(bd_labels(i,2)),1), size(output1.(bd_labels(i,2)),2)),...
        output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),ones(size(output2.(bd_labels(i,2)),1), size(output2.(bd_labels(i,2)),2)),...
        point_col1, point_col2, .25);
    overlayed_scatter_no_div(output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),1.2*ones(size(output2.(bd_labels(i,2)),1), size(output2.(bd_labels(i,2)),2)),...
        output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),1.2*ones(size(output2.(bd_labels(i,2)),1), size(output2.(bd_labels(i,2)),2)),...
        point_col2, point_col2, .35);
    set(gca, 'XTick', [0:.5:1], 'YTick', [0:.5:1], 'ZTick', [0:.5:1]);
    set(gca,'FontName','Helvetica','FontSize',12);
    set(gca,'LineWidth',2)
    set(gca, 'tickdir', 'out')
end
end

function overlayed_scatter(x1, y1, z1, x2, y2, z2,point_col1, point_col2,transparency)
if ~exist('transparency', 'var')
    transparency = .5;
end
randp_one = randperm(length(x1));
randp_two = randperm(length(x2));
div_size = 4;
for div = 1:div_size
    idx_one = randp_one((div-1)*floor(length(randp_one)/div_size)+1:(div)*floor(length(randp_one)/div_size));
    idx_two = randp_two((div-1)*floor(length(randp_two)/div_size)+1:(div)*floor(length(randp_two)/div_size));
    
    g = scatter3(x2(idx_two),y2(idx_two),z2(idx_two),'filled','MarkerFaceColor', point_col2, 'MarkerFaceAlpha', transparency);
    g.SizeData = 10;
    
    g = scatter3(x1(idx_one),y1(idx_one),z1(idx_one),'filled','MarkerFaceColor', point_col1, 'MarkerFaceAlpha', transparency);
    g.SizeData = 10;
end
end

function overlayed_scatter_no_div(x1, y1, z1, x2, y2, z2,point_col1, point_col2,transparency)
if ~exist('transparency', 'var')
    transparency = .3;
end

g = scatter3(x1,y1,z1,'filled','MarkerFaceColor', point_col1, 'MarkerFaceAlpha', transparency);
g.SizeData = 10;
g = scatter3(x2,y2,z2,'filled','MarkerFaceColor', point_col2, 'MarkerFaceAlpha', transparency);
g.SizeData = 10;
end