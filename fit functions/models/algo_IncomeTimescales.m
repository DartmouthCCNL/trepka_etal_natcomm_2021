function stats=algo_IncomeTimescales(stats,xpar)
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

alpha_fast = xpar(1);
beta = xpar(2);
alpha2_fast = xpar(3);
decay_rate_fast = xpar(4);
alpha_slow = xpar(5);
alpha2_slow = xpar(6);
decay_rate_slow = xpar(7);
slow_weight = xpar(8);

decay_base = 0;%xpar(5);
t = stats.currTrial;
if t == 1  %if this is the first trial
    stats.ql_fast(t) = 0.5;
    stats.qr_fast(t) = 0.5;
    stats.ql_slow(t) = 0.5;
    stats.qr_slow(t) = 0.5;
    stats.rpe_fast(t) = NaN;
    stats.rpe_slow(t) = NaN;
    stats.pl(t) = 0.5;
else
    %% update action values
    
    if stats.c(t-1)==-1   % if chose left on last trial
        stats.rpe_fast(t-1)=stats.r(t-1)-stats.ql_fast(t-1);
        stats.rpe_slow(t-1)=stats.r(t-1)-stats.ql_slow(t-1);
        if stats.r(t-1) > 0
            stats.ql_fast(t)=stats.ql_fast(t-1)+alpha_fast*stats.rpe_fast(t-1);
            stats.ql_slow(t)=stats.ql_slow(t-1)+alpha_slow*stats.rpe_slow(t-1);
        else
            stats.ql_fast(t)=stats.ql_fast(t-1)+alpha2_fast*stats.rpe_fast(t-1);
            stats.ql_slow(t)=stats.ql_slow(t-1)+alpha2_slow*stats.rpe_slow(t-1);          
        end
        stats.qr_fast(t)=stats.qr_fast(t-1) + decay_rate_fast*(decay_base-stats.qr_fast(t-1));
        stats.qr_slow(t)=stats.qr_slow(t-1) + decay_rate_slow*(decay_base-stats.qr_slow(t-1));
        
    elseif stats.c(t-1)==1   % else, chose right
        stats.rpe_fast(t-1)=stats.r(t-1)-stats.qr_fast(t-1);
        stats.rpe_slow(t-1)=stats.r(t-1)-stats.qr_slow(t-1);
        
        if stats.r(t-1) > 0
            stats.qr_fast(t)=stats.qr_fast(t-1)+alpha_fast*stats.rpe_fast(t-1);
            stats.qr_slow(t)=stats.qr_slow(t-1)+alpha_slow*stats.rpe_slow(t-1);            
        else
            stats.qr_fast(t)=stats.qr_fast(t-1)+alpha2_fast*stats.rpe_fast(t-1);
            stats.qr_slow(t)=stats.qr_slow(t-1)+alpha2_slow*stats.rpe_slow(t-1);           
        end
        stats.ql_fast(t)=stats.ql_fast(t-1)+ decay_rate_fast*(decay_base-stats.ql_fast(t-1));
        stats.ql_slow(t)=stats.ql_slow(t-1)+ decay_rate_slow*(decay_base-stats.ql_slow(t-1));
    end
    
    %% softmax rule for action selection
    stats.ql = slow_weight*stats.ql_slow(t) + (1-slow_weight)*stats.ql_fast(t);
    stats.qr = slow_weight*stats.qr_slow(t) + (1-slow_weight)*stats.qr_fast(t);
    stats.pl(t)=1/(1+exp(-beta*(stats.ql-stats.qr)));
    
end

end