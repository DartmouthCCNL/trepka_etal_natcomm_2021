function plot_model_fitting_results(output, models, model_colors, data_idx, only_fit, behavior_color)
model_colors=[0.2    0.2    0.2;
    0.3    0.3    0.3;
    0.4   0.4   0.4;
    0.20   0.84  0.92;
    0.20   0.64  0.92;
    0.95   0.45   0.37;
    ];
if data_idx == 1
    new_models{1} = models{15};
    new_models{1}.label = "Mult. Timescales";
    new_models{2} = models{1};
    new_models{3} = models{2};
    new_models{4} = models{5};
    new_models{4}.label = "RL2+CM (fit \gamma)";
    new_models{5} = models{9};
    new_models{5}.label = "RL2+LM (fit \gamma)";
    new_models{6} = models{13};
    new_models{6}.label = "RL2+CM+LM (fit \gamma)";
    new_models{7} = models{16};
    plot_metric_distributions_new_one(output, new_models, model_colors, data_idx, only_fit, behavior_color)
else
    new_models{1} = models{15};
    new_models{1}.label = "Mult. Timescales";
    new_models{2} = models{1};
    new_models{3} = models{2};
    new_models{4} = models{4};
    new_models{4}.label = "RL2+CM (fix \gamma)";
    new_models{5} = models{8};
    new_models{5}.label = "RL2+LM (fix \gamma)";
    new_models{6} = models{12};
    new_models{6}.label = "RL2+CM+LM (fix \gamma)";
    new_models{7} = models{16};
    plot_metric_distributions_new_two(output, new_models, model_colors, data_idx, only_fit, behavior_color)
end
end

%% helpers
function plot_metric_distributions_new_one(output, models, model_colors, data_idx, only_fit, behavior_color)
plot_aic(models, model_colors);
plot_aikake_weights(models, model_colors);

if ~only_fit
    plist = {'ERODS_loseworse', 'matching_measure'};
    plabel = ["ERODS_{W-}", 'dev. from matching'];
    for i=2:3
        figure('Position',[0,0,831.3333333333333/1.5,400]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
        hold on;
        o.X1 = output.behavior.(plist{i-1});
        colors = [behavior_color;model_colors(2,:);model_colors(end,:)]; %was [65 90 125]/256
        o.X2 = output.Income.(plist{i-1});
        o.X3 = output.(models{end-1}.name).(plist{i-1});
        my_legend = ["Obs.", "RL2", "RL2+CM+LM"];
        for ii=1:3
            [f, x, flo, fup] = ecdf(o.(strcat("X", int2str(ii))));
            shadedErrorBar(x', f', [fup'-f'; f'-flo'], {'LineWidth', 1, 'Color', colors(ii,:)});
        end
        for ii=1:3
            h(ii) = xline(nanmedian(o.(strcat("X", int2str(ii)))),'--', 'LineWidth', 1, 'Color', colors(ii,:));
        end
        for ii=1:3
            h(ii) = xline(100, 'LineWidth', 1, 'Color', colors(ii,:));
        end
        if i-1==1
            xlim([0, .5]);
        else
            xlim([-.5,0.05]);
        end
        set(gca, 'tickdir', 'out', 'linewidth',2,'fontsize',14,'fontname','Helvetica');
        xlabel(plabel(i-1));
        ylabel(strcat("fraction of data"));
        if i==2
            legend(h, my_legend, 'box', 'off', 'location', 'northeast');
        end

        xlims = xlim;
        ylims = ylim;
        wid = xlims(2)-xlims(1);
        hei = ylims(2)-ylims(1);
        x1 = xlims(1);
        y1 = ylims(1);
        ax_pos = get(gca, 'Position');
        hold on;
        [~, pInc, ks2statIncome] = kstest2(output.Income.(plist{i-1}), output.behavior.(plist{i-1}));
        [~, pMod, ks2statMod4] = kstest2(output.(models{end-1}.name).(plist{i-1}), output.behavior.(plist{i-1}));
        dstat = round(ks2statIncome*1000)/1000;
        dstat2 = round(ks2statMod4*1000)/1000;
        disp("p kstest income: " + pInc);
        disp("p kstest new mod: " + pMod);
        exponent = floor(log10(pInc));
        base = pInc * (10^(-exponent));
        inc_p_text = sprintf("%1.0f*10^{%d}", base, exponent);
        exponent = floor(log10(pMod));
        base = pMod * (10^(-exponent));
        mod_p_text = sprintf("%1.0f*10^{%d}", base, exponent);    
        text_string_inc = strcat("$\mathbf{\mathit{D}_{RL2} = ", sprintf('%.3f',dstat), "}$");
        text_string_mod = strcat("$", "\mathbf{\mathit{D}_{RL2+CM+LM} = ", sprintf('%.3f',dstat2), "}$");
        p_text_string_inc=strcat("$\mathbf{\mathit{p}_{RL2}=",inc_p_text,"}$");
        p_text_string_mod=strcat("$\mathbf{\mathit{p}_{RL2+CM+LM}=",mod_p_text,"}$");
        ax = gca;
        if i-1==1
            text(.03,1, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(.03,.94, p_text_string_inc, 'Interpreter', 'latex', 'FontSize', 11);

            text(.37, .6, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);
            text(.37,.54, p_text_string_mod, 'Interpreter', 'latex', 'FontSize', 11);

            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.07, ax_pos(2)+.5*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[0, .6]);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[0, .6]);
            my_pos = ax1.Position;
            
        else
            text(-.45, .6, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(-.45,.54, p_text_string_inc, 'Interpreter', 'latex', 'FontSize', 11);
                        
            text(-.09, .6, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);
            text(-.09,.54, p_text_string_mod, 'Interpreter', 'latex', 'FontSize', 11);

            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.08, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5],'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[-.5, .05]);
            
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[-.5, .05]);
            
        end
        if i==2
            f = figure('Position',[0,0,553,186]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
            plot_bar_plot(o.X1,o.X3,o.X2,[colors(1,:);colors(3,:);colors(2,:)],[my_legend(1), my_legend(3), my_legend(2)], [.2 .25]);
        end
        
    end
       disp("KS test for UM Income vs Behave: k=" +ks2statIncome);
    disp("KS test for UM " + models{end-1}.label + " vs Behave: k=" +ks2statMod4);

 end

end
function plot_metric_distributions_new_two(output, models, model_colors, data_idx, only_fit, behavior_color)
plot_aic(models, model_colors);
plot_aikake_weights(models, model_colors);

if ~only_fit
    plist = {'ERODS_loseworse', 'matching_measure'};
    plabel = ["ERODS_{W-}", 'dev. from matching'];
    for i=2:3
        figure('Position',[0,0,831.3333333333333/1.5,400]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
        hold on;
        o.X1 = output.behavior.(plist{i-1});
        colors = [behavior_color;model_colors(2,:);model_colors(end-2,:)]; %was [65 90 125]/256
        o.X2 = output.Income.(plist{i-1});
        o.X3 = output.(models{end-3}.name).(plist{i-1});
        my_legend = ["Obs.", "RL2", "RL2+CM"];
        for ii=1:3
            [f, x, flo, fup] = ecdf(o.(strcat("X", int2str(ii))));
            shadedErrorBar(x', f', [fup'-f'; f'-flo'], {'LineWidth', 1, 'Color', colors(ii,:)});
        end
        for ii=1:3
            xline(nanmedian(o.(strcat("X", int2str(ii)))),'--', 'LineWidth', 1, 'Color', colors(ii,:));
        end
        for ii=1:3
            h(ii) = xline(100, 'LineWidth', 1, 'Color', colors(ii,:));
        end
        if i-1==1
            xlim([0, .3]);
        else
            xlim([-.3,0.05]);
        end
        set(gca, 'tickdir', 'out', 'linewidth',2,'fontsize',14,'fontname','Helvetica');
        xlabel(plabel(i-1));
        ylabel(strcat("fraction of data"));
        if i==2
            legend(h, my_legend, 'box', 'off', 'location', 'north');
        end
        xlims = xlim;
        ylims = ylim;
        ax_pos = get(gca, 'Position');
        hold on;
        [~, pInc, ks2statIncome] = kstest2(output.Income.(plist{i-1}), output.behavior.(plist{i-1}));
        [~, pMod, ks2statMod4] = kstest2(output.(models{end-3}.name).(plist{i-1}), output.behavior.(plist{i-1}));
        dstat = round(ks2statIncome*1000)/1000;
        dstat2 = round(ks2statMod4*1000)/1000;
        disp("p kstest income: " + pInc);
        disp("p kstest new mod: " + pMod);
        exponent = floor(log10(pInc));
        base = pInc * (10^(-exponent));
        inc_p_text = sprintf("%1.0f*10^{%d}", base, exponent);
        exponent = floor(log10(pMod));
        base = pMod * (10^(-exponent));
        mod_p_text = sprintf("%1.0f*10^{%d}", base, exponent);        
        text_string_inc = strcat("$\mathbf{D_{RL2} = ", sprintf('%.3f',dstat), "}$");
        text_string_mod = strcat("$\mathbf{D_{RL2+CM} = ", sprintf('%.3f',dstat2), "}$");
        p_text_string_inc=strcat("$\mathbf{p_{RL2}=",inc_p_text,"}$");
        p_text_string_mod=strcat("$\mathbf{p_{RL2+CM}=",mod_p_text,"}$");
        ax = gca;
        if i-1==1
            text(.02,1, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(.02,.94, p_text_string_inc, 'Interpreter', 'latex', 'FontSize', 11);

            text(.22,.6, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);
            text(.22,.54, p_text_string_mod, 'Interpreter', 'latex', 'FontSize', 11);
            
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.07, ax_pos(2)+.5*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[0, .4]);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[0, .4]);
            my_pos = ax1.Position;
            
        else
            text(-.28, .65, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(-.28,.59, p_text_string_inc, 'Interpreter', 'latex', 'FontSize', 11);

            text(-.04, .65, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);
            text(-.04,.59, p_text_string_mod, 'Interpreter', 'latex', 'FontSize', 11);

            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.08, ax_pos(2)+.15*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5],'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[-.3, .05]);
            
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.15*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[-.3, .05]);
            
        end
        if i==2
            f = figure('Position',[0,0,553,186]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
            plot_bar_plot(o.X1,o.X3,o.X2,[colors(1,:);colors(3,:);colors(2,:)],[my_legend(1), my_legend(3), my_legend(2)], [.1 .15]);
        end
    end
    
    disp("KS test for UM Income vs Behave: k=" +ks2statIncome);
    disp("KS test for UM " + models{end-1}.label + " vs Behave: k=" +ks2statMod4);
end

end
function plot_aic(models, model_colors)
for i=1:numel(models)
    if ~models{i}.behav_flag
        y(i) = nanmean([models{i}.aic], 'all');
        sem_y(i) = nansem([models{i}.aic]);
        x_label{i} = models{i}.label;
    end
end
figure;
for i=1:numel(models)-1
    barh(i, y(i), 'FaceColor', model_colors(i,:));
    hold on;
end
yticklabels(x_label);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
set(gca, 'tickdir', 'out', 'Ytick', 1:numel(models)-1);
ylim([0.4 numel(models)-1+.6]);
xlim([min(y)-mean(y)/80, max(y)+mean(y)/80]);
set(gca, 'box', 'off');
xlabel("AIC");
yticklabels(x_label);
set(gcf, 'position', [    303.0000  166.3333  376.0000  213.3333]);
end
function plot_aikake_weights(models, model_colors)
for i=1:numel(models)
    if ~models{i}.behav_flag
        y(i) = nanmean([models{i}.aic], 'all');
        x_label{i} = models{i}.label;
    end
end
y = aic_weights(y);
figure;
for i=1:numel(models)-1
    barh(i, y(i), 'FaceColor', model_colors(i,:));
    hold on;
end
yticklabels(x_label);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
set(gca, 'tickdir', 'out', 'Ytick', 1:numel(models)-1);
ylim([0.4 numel(models)-1+.6]);
xlim([0,1]);
set(gca, 'box', 'off');
xlabel("Akaike weights");
yticklabels(x_label);
set(gcf, 'position', [    303.0000  166.3333  376.0000  213.3333]);

end
function plot_aic_weights(models, model_colors, field_name, data_idx)
for i=1:numel(models)
    if ~models{i}.behav_flag
        y(i) = nanmean([models{i}.aic], 'all');
        sem_y(i) = nansem([models{i}.aic]);
        x_label{i} = models{i}.label;
    end
end
all_aic_weights = [];
for ses_num = 1:length(models{1}.aic)
    ses_aics = [];
    for i=1:numel(models)
        if ~models{i}.behav_flag
                ses_aics = [ses_aics, models{i}.aic(ses_num)];
        end
    end
    all_aic_weights = [all_aic_weights; aic_weights(ses_aics)'];
end

mean_aic_weights = aic_weights(y);

y = mean(all_aic_weights, 1);
for i=1:length(y)
    sem_y(i) = nansem(all_aic_weights(:,i));
end
for i=1:numel(models)-1
    barh(i, y(i), 'FaceColor', model_colors(i,:));
    errorbar(i, y(i), sem_y(i),'horizontal','.','MarkerSize',1,'lineWidth',1.5,'color','k');
    hold on;
end



yticklabels(x_label);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
set(gca, 'tickdir', 'out', 'Ytick', 1:numel(models)-1);%numel(models));
ylim([0.4 numel(models)-1+.6]);
if data_idx == 1
    xlim([0,1]);
else
    xlim([0, 1]);
end
set(gca, 'box', 'off');
xlabel("Akaike weights");
yticklabels(x_label);
figure;
for i=1:numel(models)-1
    barh(i, y(i), 'FaceColor', model_colors(i,:));
    hold on;
    errorbar(i, sem_y(i), sem_y(i),'horizontal','.','MarkerSize',1,'lineWidth',1.5,'color','k');
    hold on;
end
yticklabels(x_label);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
set(gca, 'tickdir', 'out', 'Ytick', 1:numel(models)-1);%numel(models));
ylim([0.4 numel(models)-1+.6]);
if data_idx == 1
    xlim([0,1]);
else
    xlim([0, 1]);
end
set(gca, 'box', 'off');
xlabel("Mean aikake weight");
yticklabels(x_label);
end
function plot_bar_plot(x1, x2, x3, colors, y_label,xlims)
o.x1 = x1;
o.x2 = x2;
o.x3 = x3;
for i=1:3
    barh(i, nanmean(o.(strcat("x",int2str(i)))), 'FaceColor', colors(i,:));
    hold on;
end
dataTemp = {x1,x2,x3};
dataN = 3;
tempMean = [];
tempSEM = [];

for cntDD = 1:dataN
    tempMean(cntDD) = nanmean(dataTemp{cntDD});
    tempSEM(cntDD) = nansem(dataTemp{cntDD});
end
errorbar(tempMean,[1:3],  tempSEM,'.','horizontal','MarkerSize',1,'lineWidth',1,'color','k');

yticklabels(y_label);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
set(gca, 'tickdir', 'out', 'Ytick', 1:3);%numel(models));
ylim([0.4 3+.6]);
xlim(xlims);
set(gca, 'box', 'off');
xlabel("ERODS_{W-}");
end
function plot_side_by_side_histograms(x1, x2, colors,my_ylim)
hold on;
n = numel(x2);
%randomly select 5% of data for visualization
%purposes, and 100% of the data is infeasibly slow
index= randperm(n, ceil(n * 0.05));
violinPlot(x1, 'histOri', 'left', 'widthDiv', [2 1], 'showMM', 0, ...
    'color',  mat2cell(colors(1,:), 1));
if size(x2,1) == 1
violinPlot(x2(index)', 'histOri', 'right', 'widthDiv', [2 2], 'showMM', 0, ...
    'color',  mat2cell(colors(2,:), 1));
else
    violinPlot(x2(index), 'histOri', 'right', 'widthDiv', [2 2], 'showMM', 0, ...
    'color',  mat2cell(colors(2,:), 1));
end

set(gca, 'xtick', [], 'xticklabel', {}, 'xlim', [.5 1.5]);

% add significance stars for each bar
ylim(my_ylim);
% sigstars on top
ys = ylim;
xs = xlim;
set(gca,'FontName','Helvetica','FontSize',10,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
end