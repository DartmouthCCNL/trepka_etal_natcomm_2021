function [neglog, negloglike] = NegLogLike(pleft, pright,choice, negloglike)
    if choice==1
        logp=log(pright);
    elseif choice==-1
        logp=log(pleft);
    else
        logp=0;
    end
    neglog = -logp;
    negloglike=negloglike-logp;  % calculate log likelihood
end