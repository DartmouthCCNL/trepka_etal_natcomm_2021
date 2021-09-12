function plot_correlation_matrices(output, subs, species_color, data_idx)
%% Calculate Correlation Matrix
corr_lbls = {'pwin', 'pstay', 'winstay', 'loseswitch',...
    'delta_winstay_losestay', 'RI', ...
    'RI_B','RI_W',...
    'ERDS', 'ERDS_win', 'ERDS_lose','EODS','EODS_better','EODS_worse',...
    'ERODS', 'ERODS_winbetter', 'ERODS_losebetter', 'ERODS_winworse', 'ERODS_loseworse',...
    'matching_measure'};

matrix_labels = {"P(win)", "P(stay)", "WinStay", "LoseSwitch", "WinStay-LoseStay", "RI", "RI(better)",...
    "RI(worse)", "ERDS", "ERDS(win)", "ERDS(lose)", "EODS", "EODS(better)", "EODS(worse)","ERODS",...
   "ERODS(win,better)", "ERODS(lose,better)" , "ERODS(win,worse)", "ERODS(lose,worse)" ,"Dev. from matching"};

finalCorrSt = [];
matching_corr = struct;
for cntII = 1:length(corr_lbls)
    for cntJJ = 1:length(corr_lbls)
        lblTemp1 = corr_lbls{cntII};
        lblTemp2 = corr_lbls{cntJJ};
        
        tempData1 = output.(lblTemp1)(output.(subs(1))|output.(subs(2)));
        tempData2 = output.(lblTemp2)(output.(subs(1))|output.(subs(2)));
        
        sharedIdx = ~isnan(tempData1) & ~isnan(tempData2);

        [finalCorrSt.Pearson.R(cntII,cntJJ) , finalCorrSt.Pearson.P(cntII,cntJJ)] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx), 'type', 'Pearson');
        [finalCorrSt.Spearman.R(cntII,cntJJ) , finalCorrSt.Spearman.P(cntII,cntJJ)] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx) ,'type', 'Spearman');
        if strcmp(lblTemp2, 'matching_measure')
            disp(strcat("corr w/ matching, ",lblTemp1,": pearson r=",num2str(finalCorrSt.Pearson.R(cntII,cntJJ)),...
                " pearson p=", num2str(finalCorrSt.Pearson.P(cntII,cntJJ)), " spearman r=",num2str(finalCorrSt.Spearman.R(cntII,cntJJ)),...
                " Spearman p=", num2str(finalCorrSt.Spearman.P(cntII,cntJJ))));
            matching_corr.Pearson.R.(lblTemp1) = finalCorrSt.Pearson.R(cntII,cntJJ);
            matching_corr.Pearson.P.(lblTemp1) = finalCorrSt.Pearson.P(cntII,cntJJ);
            matching_corr.Spearman.R.(lblTemp1) = finalCorrSt.Spearman.R(cntII,cntJJ);
            matching_corr.Spearman.P.(lblTemp1) = finalCorrSt.Spearman.P(cntII,cntJJ);
        end
    end
end


%% Calculate Correlation Matrix (5/40)
temp_filt = output.(subs(1));

finalCorrSt_rewsched1 = [];
for cntII = 1:length(corr_lbls)
    for cntJJ = 1:length(corr_lbls)
        lblTemp1 = corr_lbls{cntII};
        lblTemp2 = corr_lbls{cntJJ};
        
        tempData1 = output.(lblTemp1);
        tempData2 = output.(lblTemp2);
        if size(tempData1, 1)==size(temp_filt,1)
                    sharedIdx = ~isnan(tempData1) & ~isnan(tempData2) & temp_filt;
        else
            sharedIdx = ~isnan(tempData1) & ~isnan(tempData2) & temp_filt';
        end
        [finalCorrSt_rewsched1.Pearson.R(cntII,cntJJ) , finalCorrSt_rewsched1.Pearson.P(cntII,cntJJ)] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx));
        [finalCorrSt_rewsched1.Spearman.R(cntII,cntJJ) , finalCorrSt_rewsched1.Spearman.P(cntII,cntJJ)] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx) ,'type', 'Spearman');
    end
end


%% Calculate Correlation Matrix (10/40)
temp_filt = output.(subs(2));

finalCorrSt_rewsched2 = [];
for cntII = 1:length(corr_lbls)
    for cntJJ = 1:length(corr_lbls)
        lblTemp1 = corr_lbls{cntII};
        lblTemp2 = corr_lbls{cntJJ};
        
        tempData1 = output.(lblTemp1);
        tempData2 = output.(lblTemp2);
        
        if size(tempData1, 1)==size(temp_filt,1)
                    sharedIdx = ~isnan(tempData1) & ~isnan(tempData2) & temp_filt;
        else
        sharedIdx = ~isnan(tempData1) & ~isnan(tempData2) & temp_filt';
        end
        [finalCorrSt_rewsched2.Pearson.R(cntII,cntJJ) , finalCorrSt_rewsched2.Pearson.P(cntII,cntJJ)] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx));
        [finalCorrSt_rewsched2.Spearman.R(cntII,cntJJ) , finalCorrSt_rewsched2.Spearman.P(cntII,cntJJ)] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx) ,'type', 'Spearman');
                
    end
end


%% plotting big correlation matrices
o.finalCorrSt = finalCorrSt;
o.finalCorrSt_rewsched1 = finalCorrSt_rewsched1;
o.finalCorrSt_rewsched2 = finalCorrSt_rewsched2;
reward_cat_list = ["finalCorrSt", "finalCorrSt_rewsched1", "finalCorrSt_rewsched2"];
reward_labels = [strcat(subs(1), "_and_", subs(2)), subs(1), subs(2)];
corr_type = ["Pearson", "Spearman"];
corr_type_label = ["parametric", "non-parametric"];
for i=1:length(reward_cat_list)
    for j=1:2
        figname = strcat(corr_type(j),"_",reward_labels(i));
        figure('Position', [507.85714285,676.4285714,995.857142,943.4285714], 'Name', figname);
        
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

%% plotting correlation bar graph with important metrics - pwin, pstay, win-stay, lose-switch, ERDS, EODS, ERODS, ERODS_loseworse, other ERODSs
metrics = {'pwin', 'pstay', 'winstay', 'loseswitch',...
    'delta_winstay_losestay', 'RI', ...
    'RI_B','RI_W',...
    'ERDS', 'ERDS_win', 'ERDS_lose','EODS','EODS_better','EODS_worse',...
    'ERODS', 'ERODS_winbetter', 'ERODS_losebetter', 'ERODS_winworse', 'ERODS_loseworse'};
entropy_metric_start_idx = 9;
matrix_labels = {"P(win)", "P(stay)", "WinStay", "LoseSwitch","WinStay-LoseStay", "RI", "RI(better)",...
    "RI(worse)", "ERDS", "ERDS(win)", "ERDS(lose)", "EODS", "EODS(better)", "EODS(worse)","ERODS",...
   "ERODS(win,better)", "ERODS(lose,better)" , "ERODS(win,worse)", "ERODS(lose,worse)"};
yticks = ones(length(metrics),1);
for j=1:2
    figure;
for i = 1:length(metrics)
    if i>=entropy_metric_start_idx
        if i==length(metrics)
            face_color = species_color;
            edge_color = [1 1 1];
        else
            face_color = species_color;
            edge_color = [1 1 1];
        end
        x_idx = i+1;
    else
        if i==data_idx
            face_color = species_color;
            edge_color = [1 1 1];
        else
            face_color = species_color;
            edge_color = [1 1 1];
        end
        x_idx = i;
    end
    yticks(i) = x_idx;
    
    if(matching_corr.(corr_type(j)).P.(metrics{i})<.0001)
        barh(x_idx, matching_corr.(corr_type(j)).R.(metrics{i}),'FaceColor',face_color,'EdgeColor',edge_color, 'LineWidth', 1);
    else
        face_color = [1 1 1];%species_color;
        edge_color = species_color;
        barh(x_idx, matching_corr.(corr_type(j)).R.(metrics{i}),'FaceColor',face_color,'EdgeColor',edge_color, 'LineWidth', 1);
    end
    xline(0, 'LineWidth', 1, 'Color', 'k');
    hold on;
end

set(gca,'FontName','Helvetica','FontSize',10,'FontWeight','normal',...
    'LineWidth',1, 'XTick', -1:.25:1);
set(gca, 'YTick', yticks, 'YTickLabels', matrix_labels);
set(gca, 'tickdir', 'out');
xtickangle(45);
xlim([-1 1]);
xlabel("Corr. with dev. from matching");% ("+(corr_type(j))+" R)");
set(gcf, 'position', [  360.0000  156.3333  398.3333  461.6667]);
box off;

end
