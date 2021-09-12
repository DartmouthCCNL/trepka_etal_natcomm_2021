function test_models_complete()
    load("datasets/test/test_data.mat", 'all_stats'); %load all stats structures
    [~, models] = initialize_models("cohen");
    % displays error message if fitting fails
    test_models(all_stats,models); %initialize models, fit and simulate
end