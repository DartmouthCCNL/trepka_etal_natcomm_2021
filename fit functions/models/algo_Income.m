function stats=algo_Income(stats,xpar)
% % algo_INCOME_RPE %
%PURPOSE:   Simulate player based on q-learning with reward predictione
%           errors, with differential learning rates
%AUTHORS:   Ethan Trepka 09202020
%
%INPUT ARGUMENTS
%   stats:  stats of the game thus far
%   xpar: parameters that define the player's strategy
%       xpar(1) = a - learning rate for choice yielding reward
%       xpar(2) = b - inverse temperature
%       xpar(3) = a2 - learning rate for choice yielding no reward
%
%OUTPUT ARGUMENTS
%   stats:  updated with player's probability to choose left for next step

a = xpar(1);
b = xpar(2);
a2 = xpar(3);
decay_rate = xpar(4);
decay_base = 0;%xpar(5);
t = stats.currTrial;
if t == 1  %if this is the first trial
    stats.ql(t) = 0.5;
    stats.qr(t) = 0.5;
    stats.rpe(t) = NaN;
    stats.pl(t) = 0.5;
else
    %% update action values
    
    if stats.c(t-1)==-1   % if chose left on last trial
        stats.rpe(t-1)=stats.r(t-1)-stats.ql(t-1);
        if stats.r(t-1) > 0
            stats.ql(t)=stats.ql(t-1)+a*stats.rpe(t-1);
        else
            stats.ql(t)=stats.ql(t-1)+a2*stats.rpe(t-1);
        end
        stats.qr(t)=stats.qr(t-1) + decay_rate*(decay_base-stats.qr(t-1));
    elseif stats.c(t-1)==1   % else, chose right
        stats.rpe(t-1)=stats.r(t-1)-stats.qr(t-1);
        if stats.r(t-1) > 0
            stats.qr(t)=stats.qr(t-1)+a*stats.rpe(t-1);
        else
            stats.qr(t)=stats.qr(t-1)+a2*stats.rpe(t-1);
        end
        stats.ql(t)=stats.ql(t-1)+ decay_rate*(decay_base-stats.ql(t-1));
    else  %miss trials
        stats.rpe(t-1) = 0;
        stats.ql(t)=stats.ql(t-1);
        stats.qr(t)=stats.qr(t-1);
    end
    
    %% softmax rule for action selection
    stats.pl(t)=1/(1+exp(-b*(stats.ql(t)-stats.qr(t))));
    
end

end