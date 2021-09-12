function [negloglike, nlls, pl, pr]=funIncome(xpar,dat)
alpha=xpar(1);
beta=xpar(2);
alpha2=xpar(3);
decay_rate = xpar(4);
decay_base = 0;%xpar(5);

nt=size(dat,1);
negloglike=0;

v_right=0.5;
v_left=0.5;

pl = zeros(1,nt);
pr = zeros(1,nt);
nlls = zeros(1,nt);

for k=1:nt
    
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
            v_right=v_right+alpha*(dat(k,2)-v_right);
        else
            v_right=v_right+alpha2*(dat(k,2)-v_right);
        end
        v_left = v_left + decay_rate*(decay_base-v_left);
    elseif dat(k,1)==-1 %chose left
        if dat(k,2)>0
            v_left=v_left+alpha*(dat(k,2)-v_left);
        else
            v_left=v_left+alpha2*(dat(k,2)-v_left);
        end
        v_right = v_right + decay_rate*(decay_base-v_right);
    end
end

end