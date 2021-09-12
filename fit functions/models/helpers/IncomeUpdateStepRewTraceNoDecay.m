function [v_left, v_right, rew_trace, rpe] = IncomeUpdateStepRewTraceNoDecay(reward, choice, v_left, v_right, rew_trace, pars)
alpha=pars(1);
alpha2=pars(3);
rew_alpha = pars(4);
rew_weight = pars(5);
if choice==1      %chose right
    rpe = rew_trace*rew_weight + reward-v_right;
    if reward>0
        v_right=v_right+alpha*rpe;
    else
        v_right=v_right+alpha2*rpe;
    end
elseif choice==-1 %chose left
    rpe = rew_trace*rew_weight +reward-v_left;
    if reward>0
        v_left=v_left+alpha*rpe;
    else
        v_left=v_left+alpha2*rpe;
    end
end
rew_trace = update(rew_trace, rew_alpha, reward);
end