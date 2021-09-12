function output = aic_weights(aic_array)
% Wagenmakers and Farrell 2004, pg. 193-194
aic_best_model = min(aic_array);
delta_aic_array = aic_array-aic_best_model;
rel_likelihood_array = ones(length(delta_aic_array),1);
for i = 1:length(delta_aic_array)
    rel_likelihood_array(i) = exp(-.5*delta_aic_array(i));
end
output = rel_likelihood_array./sum(rel_likelihood_array);
end