function output = behavioral_metrics(choice, reward, hr_side, stay)
% % behavioral_metrics %
%PURPOSE:   Compute behavioral metrics
%AUTHORS:   Ethan Trepka 10/05/2020
%
%INPUT ARGUMENTS
%   choice:   choice vector for block/session where -1= choose left, 1=
%       choose right. choice should not include NaN trials.
%   reward:   reward vector for block/session where 1 = reward, 
%       0 = no reward
%   hr_side:  vector of "better" side (higher reward probability) in each 
%       trial. hr_side is same length as choice and reward vectors. 
%   stay: stay vector, only REQUIRED for running average plots 

%OUTPUT ARGUMENTS
%   output: range of behavioral metrics, see code
    better = choice==hr_side;

    if ~exist('stay', 'var')
        stay = choice(1:end-1)==choice(2:end);
        rewardR = reward(1:end-1);
        betterR = better(1:end-1);
    else
        rewardR = reward;
        betterR = better;
    end
    
    output.pbetter = mean(better);
    output.pstay = mean(stay);
    output.pwin = mean(reward);
    output.pwinR = mean(rewardR);
    output.ploseR = 1-output.pwinR;
    output.pbetterR = mean(betterR);
    output.pworseR = 1-output.pbetterR;
    output.betterstay = conditional_probability(stay, betterR); 
    output.worseswitch = conditional_probability(~stay, ~betterR);
    
    output.winbetter = mean(better&reward);
    output.losebetter = mean(better&~reward);
    output.winworse = mean(~better&reward);
    output.loseworse = mean(~better&~reward);
    
    output.winstaybetter = conditional_probability(stay, betterR&rewardR);
    output.loseswitchbetter= conditional_probability(~stay, betterR&~rewardR);
    output.winstayworse = conditional_probability(stay, ~betterR&rewardR);
    output.loseswitchworse = conditional_probability(~stay, ~betterR&~rewardR);
    
    output.winstay = conditional_probability(stay, rewardR);
    output.loseswitch = conditional_probability(~stay, ~rewardR);
    output.delta_winstay_losestay = output.winstay-...
        conditional_probability(stay, ~rewardR);
    output.choice_fraction = mean(choice == -1)/(mean(choice==-1)+mean(choice==1));
    output.reward_fraction = (mean(reward==1&choice==-1))/...
        (mean(reward==1&choice==-1) + mean(reward==1&choice==1));
    output.reward_fraction1 = sum(reward==1&choice==-1)/sum(reward==1);
    output.matching_measure = output.choice_fraction-output.reward_fraction;
    output.matching_measure(output.reward_fraction<0.5) = -output.matching_measure(output.reward_fraction<0.5);

    
        output.choice_fraction_run = mean(better)/(mean(better)+mean(~better));
    output.reward_fraction_run = (mean(reward&better))/...
        (mean(reward&better) + mean(reward&~better));
    output.matching_measure_run = output.choice_fraction_run-output.reward_fraction_run;
    output.matching_measure_run(output.reward_fraction_run<0.5) = -output.matching_measure_run(output.reward_fraction_run<0.5);

%    output.matching_measure = (output.choice_fraction-...
%        output.reward_fraction)*sign(output.reward_fraction-0.5);  

    output.RI = output.pstay - (output.pbetter^2+(1-output.pbetter)^2);
    output.RI_B = mean(stay&betterR)-...
        output.pbetter^2;
    output.RI_W = mean(stay&~betterR)-...
        (1-output.pbetter)^2;
end