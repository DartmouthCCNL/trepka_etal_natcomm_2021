function [negloglike, nlls, pl, pr]=funIncomeTimescalesSimple(xpar,dat)
alpha_fast=xpar(1);
beta=xpar(2);
alpha2_fast=xpar(3);
decay_rate_fast = xpar(4);
slow_ts = xpar(5);
slow_weight = xpar(6);

alpha_slow = alpha_fast*slow_ts;
alpha2_slow = alpha2_fast*slow_ts;
decay_rate_slow = decay_rate_fast*slow_ts;

decay_base = 0;%xpar(5);

nt=size(dat,1);
negloglike=0;

v_right_fast=0.5;
v_left_fast=0.5;
v_right_slow = .5;
v_left_slow = .5;
pl = zeros(1,nt);
pr = zeros(1,nt);
nlls = zeros(1,nt);

for k=1:nt
    v_right = slow_weight*v_right_slow + (1-slow_weight)*v_right_fast; 
    v_left = slow_weight*v_left_slow + (1-slow_weight)*v_left_fast;
    pright=exp(beta*v_right)/(exp(beta*v_right)+exp(beta*v_left));
    pleft=1-pright;
    
    if pright==0
        pright=realmin;   % Smallest positive normalized floating point number, because otherwise log(zero) is -Inf
    end
    if pleft==0
        pleft=realmin;
    end
    
    %compare with actual choice to calculate log-likelihood
    if dat(k,1)==1
        logp=log(pright);
    elseif dat(k,1)==-1
        logp=log(pleft);
    else
        logp=0;
    end
    nlls(k) = -logp;
    negloglike=negloglike-logp;  % calculate log likelihood
    
    % update value for the performed action
    if dat(k,1)==1      %chose right
        if dat(k,2)>0
            v_right_fast=v_right_fast+alpha_fast*(dat(k,2)-v_right_fast);
            v_right_slow=v_right_slow+alpha_slow*(dat(k,2)-v_right_slow);
        else
            v_right_fast=v_right_fast+alpha2_fast*(dat(k,2)-v_right_fast);
            v_right_slow=v_right_slow+alpha2_slow*(dat(k,2)-v_right_slow);
        end
        v_left_fast = v_left_fast + decay_rate_fast*(decay_base-v_left_fast);
        v_left_slow = v_left_slow + decay_rate_slow*(decay_base-v_left_slow);
    elseif dat(k,1)==-1 %chose left
        if dat(k,2)>0
            v_left_fast=v_left_fast+alpha_fast*(dat(k,2)-v_left_fast);
            v_left_slow=v_left_slow+alpha_slow*(dat(k,2)-v_left_slow);
        else
            v_left_fast=v_left_fast+alpha2_fast*(dat(k,2)-v_left_fast);
            v_left_slow=v_left_slow+alpha2_slow*(dat(k,2)-v_left_slow);
        end
        v_right_fast = v_right_fast + decay_rate_fast*(decay_base-v_right_fast);
        v_right_slow = v_right_slow + decay_rate_slow*(decay_base-v_right_slow);
    end
end

end