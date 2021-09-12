function plot_simulated_correlations(output)
corr_lbls = {'alpha', 'alpha2', 'beta', 'sigma', 'alpha_sum', 'alpha_difference', 'alpha_difference_over_sigma','alpha_sum_over_sigma', 'RI', ...
    'RI_B','RI_W',...
    'ERDS', 'ERDS_win', 'ERDS_lose','EODS','EODS_better','EODS_worse',...
    'ERODS', 'ERODS_winbetter', 'ERODS_losebetter', 'ERODS_winworse', 'ERODS_loseworse',...
    'matching_measure'};
matrix_labels = {'alpha_{rew}', 'alpha_{unrew}', '\beta', '1/\beta', '\alpha_{rew} + \alpha_{unrew}', '\alpha_{rew} - \alpha_{unrew}', '\beta*(\alpha_{rew} - \alpha_{unrew})', '\beta*(\alpha_{rew} + \alpha_{unrew})',...
    "RI", "RI(better)",...
    "RI(worse)", "ERDS", "ERDS(win)", "ERDS(lose)", "EODS", "EODS(better)", "EODS(worse)","ERODS",...
   "ERODS(win,better)", "ERODS(lose,better)" , "ERODS(win,worse)", "ERODS(lose,worse)" ,"Dev. from matching"};

finalCorrSt = [];
for cntII = 1:length(corr_lbls)
    for cntJJ = 1:length(corr_lbls)
        lblTemp1 = corr_lbls{cntII};
        lblTemp2 = corr_lbls{cntJJ};
        
        tempData1 = output.(lblTemp1);
        tempData2 = output.(lblTemp2);
        if size(tempData1,2)~=1
            tempData1 = tempData1';
        end
        if size(tempData2,2)~=1
            tempData2 = tempData2';
        end
        sharedIdx = ~isnan(tempData1) & ~isnan(tempData2);

        [finalCorrSt.Pearson.R(cntII,cntJJ) , finalCorrSt.Pearson.P(cntII,cntJJ)] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx), 'type', 'Pearson');
        [finalCorrSt.Spearman.R(cntII,cntJJ) , finalCorrSt.Spearman.P(cntII,cntJJ)] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx) ,'type', 'Spearman');
    end
end
o.finalCorrSt = finalCorrSt;
reward_cat_list = ["finalCorrSt"];
corr_type = ["Pearson", "Spearman"];
corr_type_label = corr_type;
for i=1:1
    for j=1:2
        figure('Position', [507.85714285,676.4285714,1.1*995.857142,1.1*943.4285714], 'Name', corr_type(j));
        %% Plot Correlation Matrix
        tmpMat = o.(reward_cat_list(i)).(corr_type(j)).R(:,:);
        tmpMat(o.(reward_cat_list(i)).(corr_type(j)).P(:,:)>0.0001) = nan;
        h = heatmap(matrix_labels, matrix_labels, round(tmpMat,2));
        set(gca,'FontName','Helvetica','FontSize',12,'CellLabelFormat','%0.2g',...
            'ColorLimits',[-1 1],'MissingDataLabel','n.s.');
        set(h.NodeChildren(3), 'XTickLabelRotation', 45, 'YTickLabelRotation', 45, 'FontSize',16);
        set(h.NodeChildren(2),  'FontSize',25);
        set(h.NodeChildren(1),  'FontSize',25);
        h.NodeChildren(3).Title.String = corr_type_label(j);
        h.NodeChildren(3).Title.FontSize = 25;
        h.NodeChildren(3).Title.FontWeight = 'normal';
        set(gcf,'color','w')
    end
end
end