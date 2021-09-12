function plot_deviation_from_matching(output, colors, subs, sub_labels, data_idx)
output.(subs(1)) = logical(output.(subs(1)));
output.(subs(2)) = logical(output.(subs(2)));

% two histograms
figure('units','centimeters', 'Position', [3.369027777777778,1.592916666666667,25.89388888888889,13.546666666666667/2]);
warning('off', 'all');

subplot(1,3,2);
histo = histogram(output.matching_measure(output.(subs(1))), 'FaceColor',colors(1), 'EdgeColor', 'none', 'BinWidth', .01);
l1 = xline(0, 'Color', 'black', 'LineWidth', 2);
l2 = xline(nanmedian(output.matching_measure(output.(subs(1))),'all'), 'LineStyle','--', 'LineWidth', 2);
alpha(histo, 1);
l1.Alpha = 1;
l2.Alpha = 1;
xlabel('Deviation from matching');
ylabel('Number of blocks');
pbaspect([1,1,1])
set(gca,'FontName','Helvetica','FontSize', 10,'FontWeight','normal','LineWidth', 2); %, 'ylim', ylims, 'xlim', xlims%'yTick', 0:100:350, 'XTick', -0.75:.25:.5
set(gca, 'tickdir', 'out', 'box', 'off')
pbaspect([1,1,2])

subplot(1,3,3);
histo = histogram(output.matching_measure(output.(subs(2))), 'FaceColor',colors(2), 'EdgeColor', 'none', 'BinWidth', .01);
l1 = xline(0, 'Color', 'black', 'LineWidth', 2);
l2 = xline(nanmedian(output.matching_measure(output.(subs(2))),'all'), 'LineStyle','--', 'LineWidth', 2);
alpha(histo,1);
l1.Alpha = 1;
l2.Alpha = 1;
xlabel('Deviation from matching');
ylabel('Number of blocks');
set(gca,'FontName','Helvetica','FontSize', 10,'FontWeight','normal','LineWidth', 2);% 'ylim', ylims, 'xlim', xlims %,'yTick',0:0.25:1,'Xtick',0:0.25:1
set(gca, 'tickdir', 'out', 'box', 'off')
pbaspect([1,1,2])

%plot choice frac v reward frac with legends
subplot(1,3,1);
hold on

p2=plot(output.reward_fraction(output.(subs(1))),...
    output.choice_fraction(output.(subs(1))),'s','MarkerSize',1,'LineStyle','none','Color',colors(1),'LineWidth',2.5);
p3=plot(output.reward_fraction(output.(subs(2))),...
    output.choice_fraction(output.(subs(2))),'s','MarkerSize',1,'LineStyle','none','Color',colors(2),'LineWidth',2.5);
p2.MarkerSize = 5;
p3.MarkerSize = 5;
h = legend(sub_labels, 'AutoUpdate', 'off', 'Position', [0.8305,0.832,0.0837,0.0677], 'FontSize', 10);
legend box off;
set(h, 'AutoUpdate', 'off');


p1= plot([0 1], [0 1],'LineWidth', 2,'LineStyle', '--', 'Color', 'black');
alpha(p1,1);
alpha(p2,1);
alpha(p3,1);
if data_idx == 1
xlabel('Reward fraction on left');
ylabel('Choice fraction on left');
else
    xlabel('Reward fraction on circle');
ylabel('Choice fraction on circle');
end
pbaspect([1,1,1]);
xlim([0 1]);
ylim([0 1]);
set(gca,'FontName','Helvetica','FontSize', 10,'FontWeight','normal','LineWidth', 2,'yTick',0:0.25:1,'Xtick',0:0.25:1);
set(gca, 'tickdir', 'out');

%% wilcoxon signed rank test and comparison
[p_rew_sched1, ~, stats_rew_sched1] = signrank(output.matching_measure(output.(subs(1))));
disp("Wiloxon signed rank test for U.M." + sub_labels(1) + "blocks: (Z="+ stats_rew_sched1.zval + ", p=" + p_rew_sched1 + ")");
[p_rew_sched2, ~, stats_rew_sched2] = signrank(output.matching_measure(output.(subs(2))));
disp("Wiloxon signed rank test for U.M." + sub_labels(2) + "blocks: (Z="+ stats_rew_sched2.zval + ", p=" + p_rew_sched2 + ")");

end
