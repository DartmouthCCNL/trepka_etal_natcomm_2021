function[block_hr_side, five, ten, prob_left, prob_right] = compute_options(block_prob_label, block_indices)

%determining better and worse side and 5/40 10/40 blocks
left_and_right_probs = strsplit(block_prob_label,'/');
prob_left = str2num(left_and_right_probs{1});
prob_right = str2num(left_and_right_probs{2});
if prob_left>prob_right
    block_hr_side = -1*ones(length(block_indices),1);
else
    block_hr_side = ones(length(block_indices),1);
end

if (prob_left == 5 && prob_right == 40) || (prob_left == 40 && prob_right ==5)
    five = 1;
    ten = 0;
elseif (prob_left == 10 && prob_right == 40) || (prob_left == 40 && prob_right == 10)
    five = 0;
    ten = 1;
else
    five = 0;
    ten = 0;
end

prob_left = prob_left/100;
prob_right = prob_right/100;

end