function output = entropy(x)
x_unique = unique(x);
entropy_sum = 0;
for x_num = 1:length(x_unique)
    x_signal = x == x_unique(x_num);
    prob_x = mean(x_signal);
    entropy_sum = nansum_zero_helper([entropy_sum,prob_x*log2(prob_x)], 'all');
end
output = -entropy_sum;
end