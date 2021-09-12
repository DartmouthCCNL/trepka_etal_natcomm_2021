function models = test_models(all_stats, models)
disp("testing fitting & simulating:");
ses_num = length(all_stats);
%error tolerance
TOL = 1e-8;
%error 
erred = false;
%iterating over all models, excrept behavior
for k = 1:length(models)-1
    model = models{k};
    %fitting and simulating
    for sescnt = 1:ses_num
        stats = all_stats{sescnt};
        [fitpar,negloglike,~,~,~]=fit_fun(stats,model.fun,model.initpar,model.lb,model.ub);
        %get results from running fitting function
        player.label = strcat('algo_',model.name);
        player.params = fitpar;
        negloglike1 = predictAgentSimulationTest(player, stats);
        if (abs(negloglike-negloglike1)>TOL)
            disp("TEST FAILED for" + model.fun+ "- ALGO and FIT functions return different results")
            erred = true;
        end
    end
end
if ~erred
    disp("All tests passed!");
end
end