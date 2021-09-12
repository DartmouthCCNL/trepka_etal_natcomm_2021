function [negloglike, nlls, pl, pr]=funIigayaMod(xpar,dat)
fast1_weight=xpar(1);
fast2_weight=xpar(2);
slow_weight=xpar(3);
weight_sum = fast1_weight + fast2_weight + slow_weight;
fast1_weight = fast1_weight/weight_sum;
fast2_weight = fast2_weight/weight_sum;
slow_weight = slow_weight/weight_sum;

nt=size(dat,1);
negloglike=0;

i_right = .5;
i_left = .5;
i_right_slow = .5;
i_left_slow = .5;
i_right_fast1 = .5;
i_left_fast1 = .5;
i_right_fast2 = .5;
i_left_fast2 = .5;
t_fast1 = 1/xpar(4); % orig 2, 20, 100
t_fast2 = 1/xpar(5);
t_slow = 1/xpar(6);

pl = zeros(1,nt);
pr = zeros(1,nt);
nlls = zeros(1,nt);
for k=1:nt
    pright=i_right/(i_right+i_left);
    if (isnan(pright))
        pright = .5;
    end
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
        i_right_fast1=IigayaUpdateStep(t_fast1,i_right_fast1,dat(k,2));
        i_left_fast1 =IigayaUpdateStep(t_fast1,i_left_fast1,0); 
        i_right_fast2 = IigayaUpdateStep(t_fast2,i_right_fast2,dat(k,2)); 
        i_left_fast2 = IigayaUpdateStep(t_fast2,i_left_fast2,0); 
        i_right_slow = IigayaUpdateStep(t_slow,i_right_slow,dat(k,2)); 
        i_left_slow = IigayaUpdateStep(t_slow,i_left_slow,0); 
    elseif dat(k,1)==-1 %chose left
        i_right_fast1= IigayaUpdateStep(t_fast1,i_right_fast1,0);
        i_left_fast1 = IigayaUpdateStep(t_fast1,i_left_fast1,dat(k,2)); 
        i_right_fast2 = IigayaUpdateStep(t_fast2,i_right_fast2,0); 
        i_left_fast2 = IigayaUpdateStep(t_fast2,i_left_fast2,dat(k,2)); 
        i_right_slow = IigayaUpdateStep(t_slow,i_right_slow,0); 
        i_left_slow = IigayaUpdateStep(t_slow,i_left_slow,dat(k,2)); 
    end
    i_right = fast1_weight*i_right_fast1 + fast2_weight*i_right_fast2 + slow_weight*i_right_slow;
    i_left = fast1_weight*i_left_fast1 + fast2_weight*i_left_fast2 + slow_weight*i_left_slow;
end

end