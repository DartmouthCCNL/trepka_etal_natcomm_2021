function plot_choice_reward_single_session_cohen(stats, species_color)
figure('Position',[0,0,1.3*1119.333333333333/2.5,560.6666666666666/2.4]); hold on;
avg = 10;
choice = movmean(stats.c,avg);
reward = movmean(stats.c.*stats.r, avg);
plot(choice, '-','Color', species_color, 'LineWidth', 2);
plot(reward,'--','Color','k','LineWidth', 2);
legend(["choice", "reward"], 'FontName', 'Helvetica', 'FontSize', 14, 'box', 'off', 'position', [    0.7600    0.8000    0.1900    0.2200],'AutoUpdate', 'off');
for i = 2:length(stats.block_addresses)-1
    xline(stats.block_addresses(i), ':', 'Color', [.5 .5 .5],'LineWidth', 2);
end

set(gca, 'ylim', [-1 1], 'ytick', -1:.5:1, 'FontName', 'Helvetica', 'FontSize', 14, 'LineWidth', 2, 'tickdir', 'out');
xlabel("trials");
ylabel({'mean', '\Leftarrow left     right \Rightarrow'}, 'Interpreter', 'Tex');
end