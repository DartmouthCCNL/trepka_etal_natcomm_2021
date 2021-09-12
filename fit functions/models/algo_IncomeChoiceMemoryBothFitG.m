function s=algo_IncomeChoiceMemoryBothFitG(s,xpar)
t = s.currTrial;
gamma = xpar(6);
omega = xpar(5);
if t == 1  %if this is the first trial
    s.ql(t) = 0.5;
    s.qr(t) = 0.5;
    s.rpe(t) = NaN;
    s.pl(t) = 0.5;
    s.cl(t) = .5;
    s.cr(t) = .5;
else
    [s.ql(t), s.qr(t),rpe] = IncomeUpdateStep(s.r(t-1),s.c(t-1),s.ql(t-1),s.qr(t-1),xpar);
    s.cr(t) = update(s.cr(t-1), gamma, s.c(t-1)==1);
    s.cl(t) = update(s.cl(t-1), gamma, s.c(t-1)==-1);
    q_right = s.qr(t) + s.cr(t)*omega;
    q_left = s.ql(t) + s.cl(t)*omega;
    [s.pl(t), s.pr(t)] = DecisionRule(q_left, q_right, xpar(2));    
end

end