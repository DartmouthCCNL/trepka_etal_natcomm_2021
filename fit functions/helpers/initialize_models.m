function [output, models] = initialize_models(dataset_name, load_output)
if ~exist("load_output",'var')
    load_output = true;
end
% models{1}.name = 'IncomeTimescales';         % text label to refer to the models
% models{1}.fun = 'funIncomeTimescales';       % the corresponding .m code for the models
% models{1}.initpar=[.5 5 .5 .5 .05 .05 .05 .5];   % initial [alpha_reward beta alpha_noreward]
% models{1}.lb=[0 0 0 0 0 0 0 0];            % upper bound of parameters
% models{1}.ub=[1 100 1 1 1 1 1 1];          % lower bound of parameters
% models{1}.label = "RL2+Timescales";
% models{1}.behav_flag = 0;
% models{1}.color = [0.3    0.3    0.3];
% models{1}.plabels = ["arew_fast", "beta", "aunrew_fast", "decay_fast", "arew_slow", "aunrew_slow", "decay_slow", "slow_weight"];

models{1}.name = 'Return';       % text label to refer to the models
models{1}.fun = 'funReturn';     % the corresponding .m code for the models
models{1}.initpar=[0.5 5 0.5];   % initial [alpha_reward beta alpha_noreward]
models{1}.lb=[0 0 0];            % upper bound of parameters
models{1}.ub=[1 100 1];          % lower bound of parametersmodels{1}.name = 'Income';           % text label to refer to the models
models{1}.label = "RL1";
models{1}.behav_flag = 0;
models{1}.color = [0.2    0.2    0.2];
models{1}.plabels = ["arew", "beta", "aunrew"];

models{2}.name = 'Income';         % text label to refer to the models
models{2}.fun = 'funIncome';       % the corresponding .m code for the models
models{2}.initpar=[.5 5 .5 .5];   % initial [alpha_reward beta alpha_noreward]
models{2}.lb=[0 0 0 0];            % upper bound of parameters
models{2}.ub=[1 100 1 1];          % lower bound of parameters
models{2}.label = "RL2";
models{2}.behav_flag = 0;
models{2}.color = [0.3    0.3    0.3];
models{2}.plabels = ["arew", "beta", "aunrew", "decay"];

models{3}.name = 'ChoiceKernel';           % text label to refer to the models
models{3}.fun = 'funChoiceKernel';     % the corresponding .m code for the models
models{3}.initpar=[.5 5 .5 .5 .5];   % initial [alpha_reward beta alpha_noreward]
models{3}.lb=[0 0 0 0 0];            % upper bound of parameters
models{3}.ub=[1 100 1 1 1];          % lower bound of parameters
models{3}.label = "RL3";
models{3}.behav_flag = 0;
models{3}.color = [0.4    0.4    0.4];
models{3}.plabels = ["arew", "beta", "aunrew", "clr","cweight"];

l = length(models);
models{l+1}.name = 'IncomeChoiceMemoryBoth';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceMemoryBoth';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.5    0.5    0.5];
models{l+1}.plabels = ["arew", "beta", "aunrew","decay", "cweight"];

l = length(models);
models{l+1}.name = 'IncomeChoiceMemoryBothFitG';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceMemoryBothFitG';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0 .5];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1 0];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM+\gamma";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.5    0.5    0.5];
models{l+1}.plabels = ["arew", "beta", "aunrew","decay", "cweight", "gamma"];

l = length(models);
models{l+1}.name = 'IncomeChoiceMemory';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceMemory';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 0];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM+";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.6    0.6    0.6];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "cweight"];

l = length(models);
models{l+1}.name = 'IncomeChoiceMemoryFitG';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceMemoryFitG';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0 .5];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 0 0];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM+ +\gamma";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.6    0.6    0.6];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "cweight", "gamma"];

l = length(models);
models{l+1}.name = 'IncomeLossMemoryV2';           % text label to refer to the models
models{l+1}.fun = 'funIncomeLossMemoryV2';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+LM";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.7    0.7    0.7];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "lweight"];

l = length(models);
models{l+1}.name = 'IncomeLossMemoryV2FitG';           % text label to refer to the models
models{l+1}.fun = 'funIncomeLossMemoryV2FitG';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0 .5];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1 0];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+LM+\gamma";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.7    0.7    0.7];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "lweight", "gamma"];

l = length(models);
models{l+1}.name = 'IncomeLossMemoryV22';           % text label to refer to the models
models{l+1}.fun = 'funIncomeLossMemoryV22';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+LM+";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.8    0.8    0.8];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "lweight"];

l = length(models);
models{l+1}.name = 'IncomeLossMemoryV22FitG';           % text label to refer to the models
models{l+1}.fun = 'funIncomeLossMemoryV22FitG';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0 .5];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1 0];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+LM+ +\gamma";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.8    0.8    0.8];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "lweight", "gamma"];


l = length(models);
models{l+1}.name = 'IncomeChoiceRewardMemoryV6';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceRewardMemoryV6';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1 -1];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM+LM";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.9492    0.4453    0.3711];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "cweight","lweight"];

l = length(models);
models{l+1}.name = 'IncomeChoiceRewardMemoryV7';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceRewardMemoryV7';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0 0 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1 -1 0];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM+LM+\gamma";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.9492    0.4453    0.3711];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "cweight","lweight","gamma"];

l = length(models);
models{l+1}.name = 'IncomeChoiceRewardMemoryV6FitTwoG';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceRewardMemoryV6FitTwoG';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0 0 .5 .5];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1 -1 0 0];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM+LM+2\gamma";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.9492    0.4453    0.3711];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "cweight","lweight", "gamma1", "gamma2"];

l = length(models);
models{l+1}.name = 'IigayaExact';           % text label to refer to the models
models{l+1}.fun = 'funIigayaExact';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 .5 .5];   % initial [f1weight, f2weight, sweight]
models{l+1}.lb=[0 0 0];            % upper bound of parameters
models{l+1}.ub=[1 1 1];          % lower bound of parameters
models{l+1}.label = "Timescales";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.7    0.2    0.1];
models{l+1}.plabels = ["fast1weight", "fast2weight", "slowweight"];
% l = length(models);
% models{l+1}.name = 'IncomeTimescales';         % text label to refer to the models
% models{l+1}.fun = 'funIncomeTimescales';       % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 .05 .05 .05 .5];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 0 0 0 0];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1 1 1 1];          % lower bound of parameters
% models{l+1}.label = "RL2+Timescales";
% models{l+1}.behav_flag = 0;
% models{l+1}.color = [0.7    0.2    0.1];
% models{l+1}.plabels = ["arew_fast", "beta", "aunrew_fast", "decay_fast", "arew_slow", "aunrew_slow", "decay_slow", "slow_weight"];
% l = length(models);
% models{l+1}.name = 'IncomeTimescalesSimple';         % text label to refer to the models
% models{l+1}.fun = 'funIncomeTimescalesSimple';       % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 .1 .5];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 0 0];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
% models{l+1}.label = "RL2+TimescalesSimple";
% models{l+1}.behav_flag = 0;
% models{l+1}.color = [0.7    0.2    0.1];
% models{l+1}.plabels = ["arew_fast", "beta", "aunrew_fast", "decay_fast", "slow_ts","slow_weight"];


% l = length(models);
% models{l+1}.name = 'IigayaBeta';           % text label to refer to the models
% models{l+1}.fun = 'funIigayaBeta';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 .5 .5 5];   % initial [f1weight, f2weight, sweight]
% models{l+1}.lb=[0 0 0 0 ];            % upper bound of parameters
% models{l+1}.ub=[1 1 1 100];          % lower bound of parameters
% models{l+1}.label = "Timescales+Sigmoid";
% models{l+1}.behav_flag = 0;
% models{l+1}.color = [0.7    0.3    0.1];
% models{l+1}.plabels = ["fast1weight", "fast2weight", "slowweight", "beta"];
% 
% l = length(models);
% models{l+1}.name = 'IigayaMod';           % text label to refer to the models
% models{l+1}.fun = 'funIigayaMod';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 .5 .5 .5 .05 .01];   % initial [f1weight, f2weight, sweight]
% models{l+1}.lb=[0 0 0 0 0 0];            % upper bound of parameters
% models{l+1}.ub=[1 1 1 1 1 1];          % lower bound of parameters
% models{l+1}.label = "Timescales+Alpha";
% models{l+1}.behav_flag = 0;
% models{l+1}.color = [0.7    0.4    0.1];
% models{l+1}.plabels = ["fast1weight", "fast2weight", "slowweight","alpha1", "alpha2", "alpha3"];

l = length(models);
models{l+1}.name = 'behavior';
models{l+1}.label = 'Obs.';
models{l+1}.behav_flag = 1;
if(strcmp(dataset_name, "cohen"))
    models{l+1}.color = [227, 130, 29]./256;
elseif(strcmp(dataset_name, "costa"))
    models{l+1}.color = [58, 166, 154]./256;
else
    error("Enter valid dataset name...");
end

% old_models = models;
% for i=1:length(old_models)-1
%     models{i} = old_models{length(old_models)-i};
% end

output = struct;
for i=1:length(models)
    output.(models{i}.name) = struct;
end

for k=1:length(models)
    filename = strcat('output/model/',dataset_name,'/',models{k}.name,'.mat');
    if exist(filename, 'file') && load_output
        load(filename, 'model_struct');
        output.(models{k}.name) = model_struct;
        orig_struct = models{k};
        models{k} = output.(models{k}.name).model;
        models{k}.exists = 1;
        field_names = fieldnames(orig_struct);
        for cnt = 1:length(field_names)
            if ~isfield(models{k}, field_names{cnt})
                models{k}.(field_names{cnt}) = orig_struct.(field_names{cnt});
            end
        end
    else
        models{k}.exists = 0;
    end
end
end