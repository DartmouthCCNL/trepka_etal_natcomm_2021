function analyze_models_complete(calculate_output_flag)
close all;
only_fit = 0;
data_names = ["cohen", "costa"];
data_subsets = {["prob540","prob1040"],["prob7030","prob8020"]};
data_species_colors_rgb = {[227, 130, 29]./256,[58, 166, 154]./256};
sim_num  = 100;
for data_idx = 1:length(data_names)
    %% load, fit, simulate
    data_file_name = strcat('datasets/preprocessed/all_stats_', data_names(data_idx),'.mat');
    load(data_file_name, 'all_stats'); %load all stats structures
    [output, models] = initialize_models(data_names(data_idx));
    models = fitting_and_simulation(all_stats,models,data_names(data_idx), sim_num, only_fit); %initialize models, fit and simulate
    
    if ~only_fit
        %% running average computations and average computations
        disp("metrics & running averages:");
        for k=1:length(models)
            if calculate_output_flag
                if ~models{k}.exists
                    if models{k}.behav_flag
                        num_sim = 1;
                    else
                        num_sim = sim_num;
                    end
                    fprintf('%s session: ', models{k}.name);
                    all_blockcnt = 0;
                    for sescnt = 1:numel(models{k}.stats_sim)/num_sim
                        for sim_cnt = 1:num_sim
                            stats = models{k}.stats_sim{sim_cnt,sescnt};
                            for blockcnt = 1:numel(stats.block_indices)
                                all_blockcnt = all_blockcnt + 1;
                                idxes = stats.block_indices{blockcnt};
                                output.(models{k}.name) = append_to_fields(output.(models{k}.name),...
                                    {behavioral_metrics(stats.c(idxes), stats.r(idxes), stats.hr_side(idxes)),...
                                    entropy_metrics_efficient(stats.c(idxes), stats.r(idxes), stats.hr_side(idxes))});
                                output.(models{k}.name).session_and_block_and_sim{all_blockcnt} = {[sescnt, blockcnt,sim_cnt]};
                            end
                        end
                        if sescnt<=1
                            fprintf(' %d', sescnt);
                        elseif sescnt<=10
                            fprintf('\b\b %d', sescnt);
                        elseif sescnt <=100
                            fprintf('\b\b\b %d', sescnt);
                        elseif sescnt<=1000
                            fprintf('\b\b\b\b %d', sescnt);
                        else
                            fprintf('\b\b\b\b\b %d', sescnt);
                        end
                    end
                    fprintf('\n');
                end
            end
            %saving output
            output.(models{k}.name).model = models{k};
            model_struct = output.(models{k}.name);
            model_struct.model.stats_sim = [];
            if ~models{k}.exists && calculate_output_flag
                output_file_name = strcat('output/model/', data_names(data_idx),'/',models{k}.name, '.mat');
                save(output_file_name, 'model_struct');
            end
        end
    end
    %% plotting
    model_colors_rgb = [0.2    0.2    0.2;
        0.3    0.3    0.3;
        0.4    0.4    0.4;
        0.5    0.5    0.5;
        0.6    0.6    0.6;
        0.7    0.7    0.7;
        0.8    0.8    0.8;
        0.95   0.45   0.37;
        0.95   0.2   0.37;
        0.20   0.84  0.92;
        0.20   0.64  0.92;
        0.20   0.44  0.92;
        0.3    0.3    0.3;
        0.4    0.4    0.4;
        0.5    0.5    0.5;
        0.6    0.6    0.6;
        0.7    0.7    0.7;
        0.8    0.8    0.8;
        0.95   0.45   0.37;
        0.95   0.2   0.37;
        0.20   0.84  0.92;
        0.20   0.64  0.92;];
    % plot figure 5
    fig_path = strcat("figures/",data_names(data_idx),"/");
    plot_model_fitting_results(output, models, model_colors_rgb, data_idx, 0, data_species_colors_rgb{data_idx});
    save_close_figures(fig_path + "figure5_model" + models{4}.name);
    % plot figure s7
    plot_model_parameters_table(models, data_names(data_idx), data_idx);
    save_close_figures(fig_path + "figures7_model" + models{4}.name);
end
end