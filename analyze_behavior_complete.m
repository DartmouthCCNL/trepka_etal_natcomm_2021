function analyze_behavior_complete(calculate_output_flag)
close all;
data_names = ["cohen", "costa"];
data_subsets = {["prob1040","prob540"],["prob7030","prob8020"]};
data_subsets_labels = {["40/10","40/5"],["70/30","80/20"]};
data_subsets_colors = {["#EDB020", "#D95319"],["#74D3A3","#007991"]};
data_species_colors_rgb = {[227, 130, 29]./256,[58,166,154]./256};
all_output = struct;
base_fig_path = "figures/";
representative_ses_idx = [53;1];

for data_idx = 1:length(data_names)
    %initialization
    output.behavior = struct;
    output_file_name = strcat('output/behavior/behavior_',data_names(data_idx),'.mat');
    data_file_name = strcat('datasets/preprocessed/all_stats_', data_names(data_idx),'.mat');
    fig_path = strcat(base_fig_path,data_names(data_idx),"/");
    
    %load processed_data
    load(data_file_name,'all_stats');
    
    %if we want to calculate output
    if calculate_output_flag
        % compute behavior by block
        fprintf('session: ');
        all_blockcnt=0;
        for sescnt = 1:length(all_stats)
            for blockcnt = 1:length(all_stats{sescnt}.block_indices)
                %% stats for full block
                all_blockcnt = all_blockcnt + 1;
                idxes = all_stats{sescnt}.block_indices{blockcnt};
                stats.hr_side = all_stats{sescnt}.hr_side(idxes);
                stats.r = all_stats{sescnt}.r(idxes);
                stats.c = all_stats{sescnt}.c(idxes);
                if data_idx == 1
                    output.behavior.harvesting_efficiency(all_blockcnt) = nansum(all_stats{sescnt}.r(idxes))/...
                        (nansum(all_stats{sescnt}.bait_l(idxes)) + nansum(all_stats{sescnt}.bait_r(idxes)));
                end
                output.behavior = append_to_fields(output.behavior,...
                    {behavioral_metrics(stats.c, stats.r, stats.hr_side),...
                    entropy_metrics_efficient(stats.c, stats.r, stats.hr_side)});
                output.behavior.(data_subsets{data_idx}(1))(all_blockcnt) = all_stats{sescnt}.(data_subsets{data_idx}(1))(blockcnt);
                output.behavior.(data_subsets{data_idx}(2))(all_blockcnt) = all_stats{sescnt}.(data_subsets{data_idx}(2))(blockcnt);
                output.behavior.block_length(all_blockcnt) = length(idxes);
            end
            
            %%display counter
            if sescnt<=1
                fprintf(' %d', sescnt);
            elseif sescnt<=10
                fprintf('\b\b %d', sescnt);
            elseif sescnt <=100
                fprintf('\b\b\b %d', sescnt);
            elseif sescnt <=1000
                fprintf('\b\b\b\b %d', sescnt);
            else
                fprintf('\b\b\b\b\b %d', sescnt);
            end
        end
        behavior = output.behavior;
        save(output_file_name, 'behavior');
    else
        behavior = load(output_file_name, 'behavior');
        output = behavior;
    end
    fprintf('\n');
    all_output.(data_names(data_idx)) = output.behavior;
    
    %plotting
    %figure 1cd - choice averages over time
    if data_idx == 1
        plot_choice_reward_single_session_cohen(all_stats{representative_ses_idx(data_idx)},data_species_colors_rgb{data_idx});
    else
        plot_choice_reward_single_session_costa(all_stats, representative_ses_idx(data_idx),data_species_colors_rgb{data_idx});
    end
    save_close_figures(fig_path + "fig1_choice_reward");
    
    %figure 1ef - average dev. from matching over time
    plot_choice_reward_multiple_sessions(all_stats,data_subsets{data_idx},data_subsets_colors{data_idx},data_subsets_labels{data_idx}, data_idx);
    save_close_figures(fig_path + "fig1_mult_choice_reward");
    
    %figure 2 - choice fraction vs reward fraction and deviation from matching
    plot_deviation_from_matching(output.behavior, data_subsets_colors{data_idx}, data_subsets{data_idx}, data_subsets_labels{data_idx}, data_idx);
    save_close_figures(fig_path + "fig2_undermatching");
    
    %figure 4/S4 - correlation matrices between metrics
    plot_correlation_matrices(output.behavior, data_subsets{data_idx}, data_species_colors_rgb{data_idx}, data_idx);
    save_close_figures(fig_path + "fig4_correlations");
    
    %figure S3 and stepwise - using models to predict deviation from matching
    plot_stepwise_regressions(output, data_subsets_colors{data_idx}, data_subsets{data_idx}, data_subsets_labels{data_idx});
    save_close_figures(fig_path + "figS3_pred_undermatching");
end
% % figure 3 + supplement
plot_combined_metric_surfaces(all_output.(data_names(1)), all_output.(data_names(2)), data_species_colors_rgb{1}, data_species_colors_rgb{2});
save_close_figures(base_fig_path + "combined/fig3_surfaces_combined");
 
% %figure 1 + 2 in supplement
plot_combined_average_behavioral_metrics(all_output.(data_names(1)), all_output.(data_names(2)),data_subsets{1},data_subsets{2}, data_subsets_labels{1},data_subsets_labels{2},[data_subsets_colors{1},data_subsets_colors{2}]);
save_close_figures(base_fig_path + "combined/figS1_average_behavioral_metrics_combined");

%figure 1 + 2 in supplement
plot_combined_average_entropy_metrics(all_output.(data_names(1)), all_output.(data_names(2)),data_subsets{1},data_subsets{2}, data_subsets_labels{1},data_subsets_labels{2},[data_subsets_colors{1},data_subsets_colors{2}]);
save_close_figures(base_fig_path + "combined/figS2_average_entropy_metrics_combined");
end