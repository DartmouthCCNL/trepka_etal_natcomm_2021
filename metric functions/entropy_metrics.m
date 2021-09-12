function output = entropy_metrics(choice, reward, hr_side, str)
% % entropy_metrics %
%PURPOSE:   Compute ERDS, EODS, ERODS, and decompositions 
%AUTHORS:   Ethan Trepka 10/05/2020
%
%INPUT ARGUMENTS
%   choice:   choice vector for block/session where -1= choose left, 1=
%       choose right. choice should not include NaN trials.
%   reward:   reward vector for block/session where 1 = reward, 
%       0 = no reward
%   hr_side:  vector of "better" side (higher reward probability) in each 
%       trial. hr_side is same length as choice and reward vectors. 
%   str: stay/switch vector only REQUIRED when used for running averages
%OUTPUT ARGUMENTS
%   output: entropy metrics and decompositions, stored in the following
%       fields: ["ERDS", "ERDS_win", "ERDS_lose", "EODS", "EODS_better",
%       "EODS_worse", "ERODS", "ERODS_winworse", "ERODS_winbetter", 
%       "ERODS_loseworse", "ERODS_losebetter"]
if ~exist('str', 'var')
    str = choice(1:end-1)==choice(2:end);
end
rew = reward;
opt = choice == hr_side;
if length(rew)>length(str)
    rew(end)=[];
    opt(end) = [];
end
rew_and_opt = binary_to_decimal([rew, opt]);
    output = copy_field_names(struct,...
        {conditional_entropy(str, rew, "ERDS",...
            containers.Map({0,1},{'lose', 'win'})),...
        conditional_entropy(str, opt, "EODS",...
            containers.Map({0,1},{'worse', 'better'})),...
        conditional_entropy(str, rew_and_opt, "ERODS",...
            containers.Map({0, 1, 2, 3}, {'loseworse', 'losebetter',...
            'winworse', 'winbetter'})),...
            });
end