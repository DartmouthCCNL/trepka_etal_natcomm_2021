function plot_combined_average_entropy_metrics(output1,output2, subs1, subs2, sublabels1, sublabels2, color, pos)
if ~exist('pos', 'var')
    pos = 1;
end
subset1{1} = logical(output1.(subs1(1)));
subset1{2} = logical(output1.(subs1(2)));
subset2{1} = logical(output2.(subs2(1)));
subset2{2} = logical(output2.(subs2(2)));

my_xtick = {sublabels1(1),sublabels1(2), sublabels2(1), sublabels2(2)};
test_label = "reward scheds";

parameters = ["loseworse", "loseswitchworse"];
parameterLabels = ["p(lose,worse)", "p(switch|lose,worse)"];
ylims = {[10 50], [40, 80]};
f = figure;
if pos
    set(f, 'Position', [f.Position(1),f.Position(2),1233.714285714286,1.6*815.4285714285712]);
else
    set(f, 'Position', [835,395.6666666666666,863.3333333333333,1304.666666666667]);
end
for i=1:2
    dataTemp = {output1.(parameters(i))(subset1{1}); output1.(parameters(i))(subset1{2});...
        output2.(parameters(i))(subset2{1}); output2.(parameters(i))(subset2{2})};
    dataN = 4;
    tempMean = [];
    tempSEM = [];
    
    for cntDD = 1:dataN
        tempMean(cntDD) = nanmean(dataTemp{cntDD});
        tempSEM(cntDD) = nansem(dataTemp{cntDD});
    end
    
    [~, pp1, ~, stats1] = ttest2((dataTemp{1}),(dataTemp{2}));
    d1 = my_cohensD(dataTemp{1}, dataTemp{2});
    my_text1 = strcat("p=",num2str(pp1),"      d=",num2str(d1));
    disp(strcat(test_label,parameterLabels(i),": (t(",num2str(stats1.df),")=",num2str(stats1.tstat),", p=",num2str(pp1),". d=",num2str(d1)));
    [~, pp2, ~, stats2] = ttest2((dataTemp{3}),(dataTemp{4}));
    d2 = my_cohensD(dataTemp{3}, dataTemp{4});
    my_text2 = strcat("p=",num2str(pp2),"      d=",num2str(d2));
    disp(strcat(test_label,parameterLabels(i),": (t(",num2str(stats2.df),")=",num2str(stats2.tstat),", p=",num2str(pp2),". d=",num2str(d2)));
    
    subplot(3,3,i); hold on
    multby = 100;
    if i>=6
        multby = 1;
    end
    bar(tempMean(1)*multby,'FaceColor',color(1),'EdgeColor',color(1));
    hold on
    bar(2,tempMean(2)*multby, 'FaceColor',color(2),'EdgeColor',color(2));
    bar(3.5,tempMean(3)*multby, 'FaceColor', color(3), 'EdgeColor', color(3));
    bar(4.5,tempMean(4)*multby, 'FaceColor', color(4), 'EdgeColor', color(4));
    
    errorbar([1,2,3.5,4.5], tempMean*multby, tempSEM*multby,'.','MarkerSize',1,'lineWidth',1.5,'color','k');
    xlim([.5 5]);
    
    set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal',...
        'LineWidth',2, 'YTick', ylims{i}(1):(ylims{i}(2)-ylims{i}(1))/2:ylims{i}(2), 'XTick', [1,2,3.5,4.5], 'XTickLabels', my_xtick);
    set(gca, 'tickdir', 'out');
    ylim(ylims{i});
    if i<6
        yrange = ylims{i}(2)-ylims{i}(1);
        mysigstar22([1 2],max([tempMean(1)*multby,tempMean(2)*multby])+.08*yrange,pp1,gca,1.5,'down');
        mysigstar22([3.5 4.5],max([tempMean(3)*multby,tempMean(4)*multby])+.08*yrange,pp2,gca,1.5,'down');
        
        h = line(1.5, nan, 'Color', 'none');
        h = legend(h, render_p_and_d_value_combined(pp1,d1,pp2,d2), 'Location', 'northoutside', 'Interpreter', 'latex', 'FontSize', 10, 'FontName', 'Helvetica');
        if pp1>.01
            h.Position = [h.Position(1)-.01, h.Position(2)+.035, h.Position(3), h.Position(4)];
        else
            h.Position = [h.Position(1)-.015, h.Position(2)+.035, h.Position(3), h.Position(4)];
        end
        legend box off;
    elseif i>6
        yrange = ylims{i}(2)-ylims{i}(1);
        mysigstar22([1 2],max([tempMean(1)*multby,tempMean(2)*multby])+.08*yrange,pp1,gca,1.5,'down');
        mysigstar22([3.5 4.5],max([tempMean(3)*multby,tempMean(4)*multby])+.08*yrange,pp2,gca,1.5,'down');
        
        h = line(1.5, nan, 'Color', 'none');
        h = legend(h, render_p_and_d_value_combined(pp1,d1,pp2,d2), 'Location', 'northoutside', 'Interpreter', 'latex', 'FontSize', 10, 'FontName', 'Helvetica');
        if pp1>.01
            h.Position = [h.Position(1)-.01, h.Position(2)+.01, h.Position(3), h.Position(4)];
        else
            h.Position = [h.Position(1)-.015, h.Position(2)+.01, h.Position(3), h.Position(4)];
        end
        legend box off;
    else
        set(gca,'XAxisLocation','top','YAxisLocation','left');
        yrange = ylims{i}(2)-ylims{i}(1);
        mysigstar22([1 2],min([tempMean(1),tempMean(2)])-.08*yrange,pp1,gca,1.5,'up');
        mysigstar22([3.5 4.5],min([tempMean(3),tempMean(4)])-.08*yrange,pp2,gca,1.5,'up');
        
        h = line(1.5, nan, 'Color', 'none');
        h = legend(h, render_p_and_d_value_combined(pp1,d1,pp2,d2), 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', 10, 'FontName', 'Helvetica');
        if pp1>.01
            h.Position = [h.Position(1)-.01, h.Position(2)-.03, h.Position(3), h.Position(4)];
        else
            h.Position = [h.Position(1)-.01, h.Position(2)-.03, h.Position(3), h.Position(4)];
        end
        legend box off;
    end
    ylabel(parameterLabels(i));
end
end