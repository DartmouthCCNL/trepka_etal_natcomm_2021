function analyze_block_simulations_complete(calculate_output_flag)
close all;
data_names = ["cohen", "costa"];
data_subsets = {["prob540","prob1040"],["prob7030","prob8020"]};
for data_idx = 1:length(data_names)
    %% logging command line output to text file
    fig_path = strcat("figures/",data_names(data_idx),"/");
    %% initialization
    output.block_simulations = struct;
    output_file_name = strcat('output/block_simulations/block_simulations_',data_names(data_idx),'.mat');
    data_file_name = strcat('datasets/preprocessed/all_stats_', data_names(data_idx),'.mat');
    %if we want to calculate output
    if calculate_output_flag
        %% compute block_simulations by block
        load(data_file_name,'all_stats');
        
        fprintf('session: ');
        all_blockcnt=0;
        for sescnt = 1:length(all_stats)
            for blockcnt = 1:length(all_stats{sescnt}.block_indices)
                all_blockcnt = all_blockcnt + 1;
                idxes = all_stats{sescnt}.block_indices{blockcnt};
                stats.hr_side = all_stats{sescnt}.hr_side(idxes);
                stats.r = all_stats{sescnt}.r(idxes);
                stats.c = all_stats{sescnt}.c(idxes);
                stats.rewardprob = all_stats{sescnt}.rewardprob(idxes,:);
                stats = randomParameterSimulationByBlock(stats.c, stats.r, stats.rewardprob, stats.hr_side, data_names(data_idx));
                
                output.block_simulations = append_to_fields(output.block_simulations,...
                    {behavioral_metrics(stats.c, stats.r, stats.hr_side),...
                    entropy_metrics_efficient(stats.c, stats.r, stats.hr_side)});
                output.block_simulations.(data_subsets{data_idx}(1))(all_blockcnt) = all_stats{sescnt}.(data_subsets{data_idx}(1))(blockcnt);
                output.block_simulations.(data_subsets{data_idx}(2))(all_blockcnt) = all_stats{sescnt}.(data_subsets{data_idx}(2))(blockcnt);
                output.block_simulations.alpha(all_blockcnt) = stats.alpha;
                output.block_simulations.alpha2(all_blockcnt) = stats.alpha2;
                output.block_simulations.beta(all_blockcnt) = stats.beta;
                
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
        
        output.block_simulations.sigma = 1./output.block_simulations.beta;
        output.block_simulations.alpha_sum = output.block_simulations.alpha + output.block_simulations.alpha2;
        output.block_simulations.alpha_difference = output.block_simulations.alpha - output.block_simulations.alpha2;
        output.block_simulations.alpha_difference_over_sigma = output.block_simulations.alpha_difference./output.block_simulations.sigma;
        output.block_simulations.alpha_sum_over_sigma =output.block_simulations.alpha_sum./output.block_simulations.sigma;
        
        block_simulations = output.block_simulations;
        save(output_file_name, 'block_simulations');
    else
        block_simulations = load(output_file_name, 'block_simulations');
        output = block_simulations;
    end
    
    %% plotting figures
    
    %plot fig s5 correlation matrices
    plot_simulated_correlations(output.block_simulations);
    save_close_figures(fig_path + "figs5_blockwise_simulations");
end
end