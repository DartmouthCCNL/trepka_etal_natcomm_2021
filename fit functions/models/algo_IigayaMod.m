function stats=algo_IigayaMod(stats,xpar)
fast1_weight=xpar(1);
fast2_weight=xpar(2);
slow_weight=xpar(3);
weight_sum = fast1_weight + fast2_weight + slow_weight;
fast1_weight = fast1_weight/weight_sum;
fast2_weight = fast2_weight/weight_sum;
slow_weight = slow_weight/weight_sum;

t_fast1 = 1/xpar(4);
t_fast2 = 1/xpar(5);
t_slow = 1/xpar(6);

t = stats.currTrial;
if t == 1  %if this is the first trial
    stats.i_right = .5;
    stats.i_left = .5;
    stats.i_right_slow = .5;
    stats.i_left_slow = .5;
    stats.i_right_fast1 = .5;
    stats.i_left_fast1 = .5;
    stats.i_right_fast2 = .5;
    stats.i_left_fast2 = .5;
    
    stats.rpe(t) = NaN;
    stats.pl(t) = 0.5;
else
    %% update action values
    
    if stats.c(t-1)==-1   % if chose left on last trial
        stats.i_right_fast1 =IigayaUpdateStep(t_fast1,stats.i_right_fast1,0);
        stats.i_left_fast1 =IigayaUpdateStep(t_fast1,stats.i_left_fast1,stats.r(t-1)); 
        stats.i_right_fast2 = IigayaUpdateStep(t_fast2,stats.i_right_fast2,0); 
        stats.i_left_fast2 = IigayaUpdateStep(t_fast2,stats.i_left_fast2,stats.r(t-1)); 
        stats.i_right_slow = IigayaUpdateStep(t_slow,stats.i_right_slow,0); 
        stats.i_left_slow = IigayaUpdateStep(t_slow,stats.i_left_slow,stats.r(t-1)); 
    elseif stats.c(t-1)==1   % else, chose right
        stats.i_right_fast1=IigayaUpdateStep(t_fast1,stats.i_right_fast1,stats.r(t-1));
        stats.i_left_fast1 =IigayaUpdateStep(t_fast1,stats.i_left_fast1,0); 
        stats.i_right_fast2 = IigayaUpdateStep(t_fast2,stats.i_right_fast2,stats.r(t-1)); 
        stats.i_left_fast2 = IigayaUpdateStep(t_fast2,stats.i_left_fast2,0); 
        stats.i_right_slow = IigayaUpdateStep(t_slow,stats.i_right_slow,stats.r(t-1)); 
        stats.i_left_slow = IigayaUpdateStep(t_slow,stats.i_left_slow,0); 
    end
    
    %% softmax rule for action selection
    stats.i_right = fast1_weight*stats.i_right_fast1 + fast2_weight*stats.i_right_fast2 + slow_weight*stats.i_right_slow;
    stats.i_left = fast1_weight*stats.i_left_fast1 + fast2_weight*stats.i_left_fast2 + slow_weight*stats.i_left_slow;
    stats.pl(t)= stats.i_left/(stats.i_left + stats.i_right);
    if (isnan(stats.pl(t)))
        stats.pl(t) = .5;
    end
end

end