function plot_choice_reward_single_session_costa(all_stats,representative_ses_idx, species_color)
block_idx = all_stats{representative_ses_idx}.abs_superblock_idx;
stats = struct;
stats.c = [];
stats.r = [];
stats.block_addresses = [];
for i = 1:block_idx
    stats.c = [stats.c; all_stats{representative_ses_idx-block_idx + i}.c];
    stats.r = [stats.r; all_stats{representative_ses_idx-block_idx + i}.r];
    stats.block_addresses = [stats.block_addresses; all_stats{representative_ses_idx-block_idx + i}.block_addresses(2)  + 80*(i-1); 80*i];
end
idx = representative_ses_idx + 1;
while all_stats{idx}.abs_superblock_idx ~= 1
    stats.c = [stats.c; all_stats{idx}.c];
    stats.r = [stats.r; all_stats{idx}.r];
    stats.block_addresses = [stats.block_addresses; all_stats{idx}.block_addresses(2) + 80*(idx-1); 80*idx];    
    idx = idx + 1;
end
num_blocks = 5;
stats.c = stats.c(1:num_blocks*80);
stats.r = stats.r(1:num_blocks*80);
stats.block_addresses = stats.block_addresses(1:num_blocks*2);
figure('Position',[0,0,1.3*1119.333333333333/2.5,560.6666666666666/2.4]); hold on;
avg = 10;

choice = [];
reward = [];
for i = 1:num_blocks
    tstats = struct;
    tstats.c = stats.c((i-1)*80+1:i*80);
    tstats.r = stats.r((i-1)*80+1:i*80);
    choice((i-1)*80+1:i*80) = movmean(tstats.c,avg);    
    reward((i-1)*80+1:i*80) = movmean(tstats.c.*tstats.r, avg);
    plot((i-1)*80+1:i*80,choice((i-1)*80+1:i*80), '-','Color', species_color, 'LineWidth', 2);
    plot((i-1)*80+1:i*80,reward((i-1)*80+1:i*80),'--','Color','k','LineWidth', 2);
end


legend(["choice", "reward"], 'FontName', 'Helvetica', 'FontSize', 14, 'box', 'off', 'Position', [0,0,0.186139747995418,0.234375],'AutoUpdate', 'off');
for i = 1:length(stats.block_addresses)-1
    if (mod(stats.block_addresses(i),80) == 0)
        xline(stats.block_addresses(i), '-', 'Color', 'k','LineWidth', 2);
    else
        xline(stats.block_addresses(i), ':', 'Color', [.5 .5 .5],'LineWidth', 2);
    end
end

set(gca, 'ylim', [-1 1], 'ytick', -1:.5:1, 'FontName', 'Helvetica', 'FontSize', 14, 'LineWidth', 2, 'tickdir', 'out');
xlabel("trials");
ylabel({'mean', '\Leftarrow circle   square \Rightarrow'}, 'Interpreter', 'Tex');
end