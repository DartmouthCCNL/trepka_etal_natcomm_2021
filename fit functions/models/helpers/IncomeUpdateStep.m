function [v_left, v_right, rpe] = IncomeUpdateStep(reward, choice, v_left, v_right, pars)
alpha=pars(1);
alpha2=pars(3);
decay_rate = pars(4);
decay_base = 0;%pars(5);

if choice==1      %chose right
    rpe = reward-v_right;
    if reward>0
        v_right=v_right+alpha*(reward-v_right);
    else
        v_right=v_right+alpha2*(reward-v_right);
    end
    v_left = v_left + decay_rate*(decay_base-v_left);
elseif choice==-1 %chose left
    rpe = reward-v_left;
    if reward>0
        v_left=v_left+alpha*(reward-v_left);
    else
        v_left=v_left+alpha2*(reward-v_left);
    end
    v_right = v_right + decay_rate*(decay_base-v_right);
end
end