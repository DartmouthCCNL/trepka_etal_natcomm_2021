function output = conditional_entropy(y, x, metric_name, decomp_map)
% % conditional_entropy %
%PURPOSE:   Compute conditional entropy H(y|x) from two logical vectors 
%AUTHORS:   Ethan Trepka 10/05/2020
%
%INPUT ARGUMENTS
%   y: vector of conditioned variable, each uq value is an event, e.g. 1 =
%       stay, 0 = switch
%   x:  vector of conditioning variable, each value is an event 
%   metric_name: string, name of conditional entropy metric
%   decomp_map: map from "events" in x to strings to label to 
%       decompositions that corresponds with the label, e.g.
%       {1,0->"win","lose"}

%OUTPUT ARGUMENTS
%   output: 
%       (metric_name)
%       (metric_name + _ + decomp_map values)
y_unique = unique(y);
x_unique = unique(x);

if ~exist('decomp_map', 'var')
    decompose_flag = false;
else
    decompose_flag = true;
end
%initialize entropy decompositions to NaN
if decompose_flag
decomp_vals = values(decomp_map);
for i=1:decomp_map.Count
    output.(strcat(metric_name, "_", decomp_vals(i))) = NaN;
end
end
x_entropies_storage = [NaN];
for x_num = 1:length(x_unique)
    x_entropy = 0; %initial value of current entropy decomposition
    
    x_signal = x == x_unique(x_num);
    prob_x = mean(x_signal);
    for y_num = 1:length(y_unique)
        y_signal = y == y_unique(y_num);
        prob_x_given_y = conditional_probability(y_signal,x_signal);
        x_entropy = nansum_zero_helper([x_entropy,...
            prob_x_given_y*prob_x*log2(prob_x_given_y)], 'all');
    end
    if decompose_flag
    output.(strcat(metric_name, "_", decomp_map(x_unique(x_num)))) = -x_entropy;
    end
    x_entropies_storage = [x_entropies_storage, -x_entropy];
end

output.(metric_name) = nansum_zero_helper(x_entropies_storage, 'all');

end