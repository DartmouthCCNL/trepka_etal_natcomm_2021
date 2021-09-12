function plot_stepwise_regressions(output, colors, subs, sub_labels, stepwise_crit)
output.behavior.(subs(1)) = logical(output.behavior.(subs(1)));
output.behavior.(subs(2)) = logical(output.behavior.(subs(2)));

if ~exist('stepwise_crit','var')
    stepwise_crit = .0001;
end
labels = ["ERDS_+", "ERDS_-", "p(win)", "p(stay)", "WinStay", "LoseSwitch", "RI_B", "RI_W", "ERODS_B", "ERODS_W", "EODS_B", "EODS_W", ];
figure('Position', [-45.857142857142854,938.7142857142857,1200,400]);
hold on;
disp(newline);
disp("=======STEPWISE REGRESIONS=========");
for j=1:4
    if j==4
        labels = ["ERDS_+", "ERDS_-", "p(win)", "p(stay)", "WinStay",...
            "LoseSwitch", "RI_B", "RI_W", "ERODS_{B+}",...
            "ERODS_{W+}", "ERODS_{B-}", "ERODS_{W-}", "EODS_B", "EODS_W", ];
        dataMtx = [...
            output.behavior.ERDS_win,...                 %1
            output.behavior.ERDS_lose,...                %2
            output.behavior.pwin,...                      %3
            output.behavior.pstay,...                     %4
            output.behavior.winstay,...      %5
            output.behavior.loseswitch,...    &6
            output.behavior.RI_B,...                      %8
            output.behavior.RI_W,...                      %9
            output.behavior.ERODS_winbetter,...           %12
            output.behavior.ERODS_winworse,...            %13
            output.behavior.ERODS_losebetter,...          %12
            output.behavior.ERODS_loseworse,...           %13
            output.behavior.EODS_better,...             %10
            output.behavior.EODS_worse,...            %11
            ];
        parameterLabels = "Model(full) U.M., top 3 predictors";
        num_steps = 3;
    elseif j==3
        labels = ["ERDS_+", "ERDS_-", "p(win)", "p(stay)", "WinStay",...
            "LoseSwitch", "RI_B", "RI_W", "ERODS_{B+}",...
            "ERODS_{W+}", "ERODS_{B-}", "ERODS_{W-}", "EODS_B", "EODS_W", ];
        dataMtx = [...
            output.behavior.ERDS_win,...                 %1
            output.behavior.ERDS_lose,...                %2
            output.behavior.pwin,...                      %3
            output.behavior.pstay,...                     %4
            output.behavior.winstay,...      %5
            output.behavior.loseswitch,...    &6
            output.behavior.RI_B,...                      %8
            output.behavior.RI_W,...                      %9
            output.behavior.ERODS_winbetter,...           %12
            output.behavior.ERODS_winworse,...            %13
            output.behavior.ERODS_losebetter,...          %12
            output.behavior.ERODS_loseworse,...           %13
            output.behavior.EODS_better,...             %10
            output.behavior.EODS_worse,...            %11
            ];
        parameterLabels = "Model (full) U.M.";
        num_steps = 10000000;
    elseif j == 2
        labels = ["p(win)", "p(stay)", "WinStay", "LoseSwitch", "RI_B", "RI_W"];
        
        dataMtx = [...
            output.behavior.pwin,...                      %3
            output.behavior.pstay,...                     %4
            output.behavior.winstay,...      %5
            output.behavior.loseswitch,...    &6
            output.behavior.RI_B,...                      %8
            output.behavior.RI_W,...                      %9
            ];
        parameterLabels = "Model (no entropy) U.M.";
        num_steps = 10000000;
    elseif j==1
        labels = ["p(win)", "p(stay)", "WinStay", "LoseSwitch"];
        
        dataMtx = [...
            output.behavior.pwin,...                      %3
            output.behavior.pstay,...                     %4
            output.behavior.winstay,...      %5
            output.behavior.loseswitch...    &6
            ];
        parameterLabels = "Model (no entropy/repetition) U.M.";
        num_steps = 10000000;
    end
    
    [b,se,pval,finalmodel,stats,nextstep,history] = stepwisefit(dataMtx,...
        output.behavior.matching_measure, 'PEnter', stepwise_crit,'PRemove', stepwise_crit+stepwise_crit/10, 'Display', 'off', 'MaxIter', num_steps); %if using stepwiselm, 'Upper', 'linear',
    mdl = stepwiselm(dataMtx,...
        output.behavior.matching_measure, 'Upper', 'linear', 'PEnter', stepwise_crit,'PRemove', stepwise_crit+stepwise_crit/10, 'Verbose', 0, 'NSteps', num_steps); %if using stepwiselm, ,
    disp(parameterLabels);
    disp(strcat("Adj. R squared: ", num2str(mdl.Rsquared.Adjusted)));
    %% calculating r^2 values for each step
    for i=1:length(history.rmse)
        sse = history.rmse(i)^2*sum(~stats.wasnan);
        yvar = output.behavior.matching_measure(~stats.wasnan);
        tss = sum((yvar-mean(yvar)).^2);
        r2(i) = 1-sse/tss;
        if i>1
            delta_r2(i) = r2(i)-r2(i-1);
        else
            delta_r2(i) = r2(i);
        end
    end
    disp("stepwise sample size: " + sum(~stats.wasnan));
    %% predicting matching with cross validation
    nanDataMtx = isnan(dataMtx);
    removeRowsIdx = sum(nanDataMtx, 2)>0;
    dataMtx(removeRowsIdx, :) = [];
    
    matching_measure_Nonan = output.behavior.matching_measure;
    prob_rewsched1_Nonan = output.behavior.(subs(1));
    prob_rewsched2_Nonan = output.behavior.(subs(2));
    
    matching_measure_Nonan(removeRowsIdx) = [];
    prob_rewsched1_Nonan(removeRowsIdx) = [];
    prob_rewsched2_Nonan(removeRowsIdx) = [];
    rng('default')
    rng shuffle
    CVMdl = fitrlinear(dataMtx, matching_measure_Nonan, 'CrossVal', 'on');
    predicted_matching = kfoldPredict(CVMdl);
    subplot(1,4,j);
    hold on;
    if nanmean(output.behavior.matching_measure(output.behavior.(subs(1))))<-.1
        ylims = [-.2, -.1];
    else
        ylims = [-.15 -.05];
    end
    if j<=3
        dataTemp = {predicted_matching(prob_rewsched1_Nonan); predicted_matching(prob_rewsched2_Nonan)};
    else
        dataTemp = {output.behavior.matching_measure(output.behavior.(subs(1))), output.behavior.matching_measure(output.behavior.(subs(2)))};
    end
    dataN = 2;
    tempMean = [];
    tempSEM = [];
    for cntDD = 1:dataN
        tempMean(cntDD) = nanmean(dataTemp{cntDD});
        tempSEM(cntDD) = nansem(dataTemp{cntDD});
    end
    
    [~, pp, ~, stats1] = ttest2((dataTemp{1}),(dataTemp{2}));
    d1 = my_cohensD(dataTemp{1}, dataTemp{2});
    disp(strcat(sub_labels(1)," vs ",sub_labels(2)," ",parameterLabels,": (t(",num2str(stats1.df),")=",num2str(stats1.tstat),", p=",num2str(pp),". d=",num2str(d1)));
    
    hold on
    multby = 1;
    bar(tempMean(1)*multby,'FaceColor',colors(1),'EdgeColor',colors(1));
    hold on
    bar(2,tempMean(2)*multby, 'FaceColor',colors(2),'EdgeColor',colors(2));
    errorbar([1:2], tempMean*multby, tempSEM*multby,'.','MarkerSize',1,'lineWidth',1.5,'color',"#000000");
    xlim([.5 2.5]);
    set(gca,'FontName','Helvetica','FontSize',15,'FontWeight','normal',...
        'LineWidth',3, 'YTick', ylims(1):(ylims(2)-ylims(1))/2:ylims(2), 'XTick', 1:1:2, 'XTickLabels', {sub_labels(1),sub_labels(2)});
    set(gca, 'tickdir', 'out');
    ylim(ylims);
    set(gca,'XAxisLocation','top','YAxisLocation','left');
    if j<=3
        ylabel(parameterLabels);
    else
        ylabel("Observed U.M.");
    end
    mysigstar22([1 2],min([tempMean(1),tempMean(2)])-.008,pp,gca,1.5,'up');
    h = line(1.5, nan, 'Color', 'none');
    
    h = legend(h, render_p_and_d_value(pp,d1), 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', 10, 'FontName', 'Helvetica');
    if pp>.01
        h.Position = [h.Position(1), h.Position(2)-.02, h.Position(3), h.Position(4)];
    else
        h.Position = [h.Position(1)+.02, h.Position(2)-.02, h.Position(3), h.Position(4)];
    end
    legend box off;
    disp('Stepwise process:');
    prev = zeros(1, size(history.in, 2));
    process_string = "";
    for i=1:size(history.in, 1)
        diff = history.in(i, :) - prev;
        if (sum(diff)<0)
            process_string = strcat(process_string, "Removed ");
        elseif (sum(diff)>0)
            process_string = strcat(process_string, "Added ");
        end
        process_string = strcat(process_string, labels(find(diff)), ", dr^2=" +sprintf('%0.4f',delta_r2(i))+", RMSE = ",...
            ""+sprintf('%0.4f',history.rmse(i)), ", p < ", sprintf('%0.2e',mdl.Steps.History.pValue(i+1)),...
            ". ");
        prev = history.in(i, :);
    end
    disp(process_string);
    %final equation
    reg_eq = b'.*finalmodel;
    disp('Final regression equation:');
    eq_string = "UM =";
    reg_eq_idx = find(finalmodel);
    for i=1:sum(finalmodel)
        eq_string = strcat(eq_string, "+", sprintf('%0.2f', reg_eq(reg_eq_idx(i))), "*", labels(reg_eq_idx(i)));
    end
    eq_string = strcat(eq_string, " +", sprintf('%0.2f', stats.intercept));
    disp(eq_string);
    disp(newline);
end
end