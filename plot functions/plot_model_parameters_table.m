function T = plot_model_parameters_table(models, dataset_name, data_idx)
model_colors=[0.2    0.2    0.2;
    0.3    0.3    0.3;
    0.4   0.4   0.4;
    0.20   0.84  0.92;
    0.20   0.64  0.92;
    0.95   0.45   0.37;
    ];
old_models = models;
if data_idx == 1
    new_models{1} = models{15};
    
    new_models{2} = models{1};
    new_models{3} = models{2};
    new_models{4} = models{5};
    new_models{4}.label = "RL2+CM (fit \gamma)";
    new_models{5} = models{9};
    new_models{5}.label = "RL2+LM (fit \gamma)";
    new_models{6} = models{13};
    new_models{6}.label = "RL2+CM+LM (fit \gamma)";
    new_models{7} = models{16};
else
    new_models{1} = models{15};
    
    new_models{2} = models{1};
    new_models{3} = models{2};
    new_models{4} = models{4};
    new_models{4}.label = "RL2+CM (fix \gamma)";
    new_models{5} = models{8};
    new_models{5}.label = "RL2+LM (fix \gamma)";
    new_models{6} = models{12};
    new_models{6}.label = "RL2+CM+LM (fix \gamma)";
    new_models{7} = models{16};
end
models = new_models;

filename = strcat('output/model/',dataset_name,'/behavior.mat');
load(filename, 'model_struct');
behav_struct = model_struct;
model_labels = {};
ks_stat_matching = {};
ks_stat_erodsw = {};
aic_mean = {};
aic_sem = {};
erodsw_mean = {};
erodsw_sem = {};
aics = [];
bics = [];
aic_mean_for_weights = [];


all_stats = behav_struct.model.stats_sim;
sim_idxes = [];
models_ptable = zeros(length(models)-1,6);
plabels = ["arew", "beta", "aunrew", "decay", "cweight","lweight"];
plabels_label = ["\alpha_{rew}", "\beta", "\alpha_{unrew}", "decay rate", "\omega_{CM}", "\omega_{LM}"];
pbounds = [0,1;0,100;0,1;0,1;-1,1;-1,1];
ses_lengths = nan(length(all_stats),1);


all_stats = models{end}.stats_sim;
sim_idxes = [];
models_ptable = zeros(length(models)-1,6);
plabels = ["arew", "beta", "aunrew", "decay", "cweight","lweight"];
plabels_label = ["\alpha_{rew}", "\beta", "\alpha_{unrew}", "decay rate", "\omega_{CM}", "\omega_{LM}"];
pbounds = [0,1;0,100;0,1;0,1;-1,1;-1,1];
ses_lengths = nan(length(all_stats),1);
for sescnt = 1:length(all_stats)
    stats = all_stats{sescnt};
    ses_lengths(sescnt) = length(stats.c);
    num_blocks = length(stats.block_indices);
    for i=1:100
        sim_idxes(end+1:end+num_blocks) = i;
    end
end
for k=1:length(models)
    if ~models{k}.behav_flag
        filename = strcat('output/model/',dataset_name,'/',models{k}.name,'.mat');
        load(filename, 'model_struct');
        
        model_labels{k} = model_struct.model.label;
        
        aic = model_struct.model.aic(:,1);
        
        aics = [aics, aic];
        aic_mean{k} = nanmean(aic);
        aic_mean_for_weights(k) = nanmean(aic);
        aic_sem{k} = nansem(aic);
        
        bic = model_struct.model.bic(:,1);
        bic_mean{k} = nanmean(bic);
        
        ll = model_struct.model.ll(:,1);
        ll_mean{k} = nanmean(ll);
        
        mcfadden_r_squared = 1-nansum(ll)/(nansum(ses_lengths.*(-log(.5))));
        mrs{k} = mcfadden_r_squared;
        % get erodsw
        erodsw = model_struct.ERODS_loseworse;
        erodsw_mean{k} = nanmean(erodsw);
        erodsw_sem{k} = nansem(erodsw);
        plabel = ["ERODS_{W-}", 'dev. from matching'];
        [~, ~, ks_stat_matching{k}] = kstest2(model_struct.matching_measure, behav_struct.matching_measure);
        [~, ~, ks_stat_erodsw{k}] = kstest2(model_struct.ERODS_loseworse, behav_struct.ERODS_loseworse);
        models{k}.erodsw_comp = nan(100,1);
        erodsw = model_struct.ERODS_loseworse;
        matchingg = model_struct.matching_measure;
        fparmat = cell2mat(model_struct.model.fitpar);
        for i=1:length(plabels)
            if any(strcmp(models{k}.plabels, plabels(i)))
                models_ptable(k,i) = 1;
                par_valu = find(strcmp(models{k}.plabels, plabels(i)));
                [f, phi] = ksdensity(fparmat(:,par_valu),'Support', pbounds(i,:),'BoundaryCorrection','reflection');
                models{k}.(plabels(i)).f = f;
                models{k}.(plabels(i)).phi = phi;
                models{k}.(plabels(i)).x = fparmat(:,par_valu);
            end
        end
    end
end
better_than_Dyn_RCM = [];
if data_idx == 1
    aic_idx = 6;
else
    aic_idx = 4;
end
for k=1:length(models)-1
    [h, p] = ttest(aics(:,k),aics(:,aic_idx));
    better_than_Dyn_RCM(k) = p;
    aic_diffs(k) = (nanmean(aics(:,k))-nanmean(aics(:,aic_idx)));
end

aic_weight_array = aic_weights(aic_mean_for_weights);

%%parameter distrubtion plot
%parameter distributions
mod_to_plot = [3,4,5,6];
figure('Position',[521,773,732,913]);
for p_idx = 1:length(plabels)
    subplot(3,2,p_idx);
    hold on;
    legend_label = [];
    for k = 1:length(models)-1
        if ismember(k, mod_to_plot)
            if models_ptable(k,p_idx)==1
                legend_label = [legend_label; models{k}.label];
                plot(models{k}.(plabels(p_idx)).phi,models{k}.(plabels(p_idx)).f, 'LineWidth', 2, 'Color', model_colors(k,:)); % matching convergence
                x = models{k}.(plabels(p_idx)).x;
                xline(nanmean(x),'--','Color',model_colors(k,:),'LineWidth',2,'HandleVisibility','off');
            end
        end
    end
    xlabel(plabels_label(p_idx));
    xlim(pbounds(p_idx,:));
    if mod(p_idx,2)==1
    end
    if p_idx>4
        xline(0, '--k', 'LineWidth', 2);
    end
    set_axis_defaults();
    if (p_idx == 1 || p_idx == 3 || p_idx == 5)
        ylabel("prob. density");
    end
    if (p_idx ==1 || p_idx == 5 || p_idx == 6)
        legend(legend_label, 'box', 'off');
    end
end

pos = get(gcf, 'position');
set(gcf, 'position', [ 0 0 pos(3)/2 pos(4)/2]);

%%building the table
models = old_models;
if data_idx == 1
    new_models{1} = models{15};
    
    new_models{2} = models{1};
    new_models{3} = models{2};
    new_models{4} = models{5};
    new_models{4}.label = "RL2+CM (fit \gamma)";
    new_models{5} = models{9};
    new_models{5}.label = "RL2+LM (fit \gamma)";
    new_models{6} = models{13};
    new_models{6}.label = "RL2+CM+LM (fit \gamma)";
    new_models{7} = models{7};
    new_models{8} = models{11};
    new_models{9} = models{3};
    new_models{10} = models{16};
else
    new_models{1} = models{15};  
    new_models{2} = models{1};
    new_models{3} = models{2};
    new_models{4} = models{4};
    new_models{4}.label = "RL2+CM (fix \gamma)";
    new_models{5} = models{8};
    new_models{5}.label = "RL2+LM (fix \gamma)";
    new_models{6} = models{12};
    new_models{6}.label = "RL2+CM+LM (fix \gamma)";
    new_models{7} = models{6};
    new_models{8} = models{10};
    new_models{9} = models{3};
    new_models{10} = models{16};
end
models = new_models;

all_stats = models{end}.stats_sim;
sim_idxes = [];
models_ptable = zeros(length(models)-1,6);
plabels = ["arew", "beta", "aunrew", "decay", "cweight","lweight"];
plabels_label = ["\alpha_{rew}", "\beta", "\alpha_{unrew}", "decay rate", "\omega_{CM}", "\omega_{LM}"];
pbounds = [0,1;0,100;0,1;0,1;-1,1;-1,1];
ses_lengths = nan(length(all_stats),1);
for sescnt = 1:length(all_stats)
    stats = all_stats{sescnt};
    ses_lengths(sescnt) = length(stats.c);
    num_blocks = length(stats.block_indices);
    for i=1:100
        sim_idxes(end+1:end+num_blocks) = i;
    end
end
for k=1:length(models)
    if ~models{k}.behav_flag
        filename = strcat('output/model/',dataset_name,'/',models{k}.name,'.mat');
        load(filename, 'model_struct');
        
        model_labels{k} = model_struct.model.label;
        
        aic = model_struct.model.aic(:,1);
        
        aics = [aics, aic];
        aic_mean{k} = nanmean(aic);
        aic_mean_for_weights(k) = nanmean(aic);
        aic_sem{k} = nansem(aic);
        
        bic = model_struct.model.bic(:,1);
        bic_mean{k} = nanmean(bic);
        
        ll = model_struct.model.ll(:,1);
        ll_mean{k} = nanmean(ll);
        
        mcfadden_r_squared = 1-nansum(ll)/(nansum(ses_lengths.*(-log(.5))));
        mrs{k} = mcfadden_r_squared;
        % get erodsw
        erodsw = model_struct.ERODS_loseworse;
        erodsw_mean{k} = nanmean(erodsw);
        erodsw_sem{k} = nansem(erodsw);
        plabel = ["ERODS_{W-}", 'dev. from matching'];
        [~, ~, ks_stat_matching{k}] = kstest2(model_struct.matching_measure, behav_struct.matching_measure);
        [~, ~, ks_stat_erodsw{k}] = kstest2(model_struct.ERODS_loseworse, behav_struct.ERODS_loseworse);
        models{k}.erodsw_comp = nan(100,1);
        erodsw = model_struct.ERODS_loseworse;
        matchingg = model_struct.matching_measure;
        fparmat = cell2mat(model_struct.model.fitpar);
        for i=1:length(plabels)
            if any(strcmp(models{k}.plabels, plabels(i)))
                models_ptable(k,i) = 1;
                par_valu = find(strcmp(models{k}.plabels, plabels(i)));
                [f, phi] = ksdensity(fparmat(:,par_valu),'Support', pbounds(i,:),'BoundaryCorrection','reflection');
                models{k}.(plabels(i)).f = f;
                models{k}.(plabels(i)).phi = phi;
                models{k}.(plabels(i)).x = fparmat(:,par_valu);
            end
        end
    end
end
better_than_Dyn_RCM = [];
if data_idx == 1
    aic_idx = 6;
else
    aic_idx = 4;
end
for k=1:length(models)-1
    [h, p] = ttest(aics(:,k),aics(:,aic_idx));
    better_than_Dyn_RCM(k) = p;
    aic_diffs(k) = (nanmean(aics(:,k))-nanmean(aics(:,aic_idx)));
end

aic_weight_array = aic_weights(aic_mean_for_weights);
T = table(model_labels', aic_mean', aic_sem',better_than_Dyn_RCM',aic_diffs',ll_mean',bic_mean',mrs', erodsw_mean', erodsw_sem',ks_stat_erodsw', ks_stat_matching', 'VariableNames', ["model", "aic", "aicsem", "ttest","aicdiff", "ll","bic","mcfaddenr","ERODSw", "ERODSwsem", "DERODSw", "DMatching"]);
disp(T);
