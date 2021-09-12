function [negloglike, nlls]=funIncomeChoiceMemoryBoth(xpar,dat)
% % funDQ_RPE %
%PURPOSE:   Function for maximum likelihood estimation, called by fit_fun().
%
%INPUT ARGUMENTS
%   xpar:       alpha, beta, alpha2
%   dat:        data
%               dat(:,1) = choice vector
%               dat(:,2) = reward vector
%
%OUTPUT ARGUMENTS
%   negloglike:      the negative log-likelihood to be minimized

negloglike=0;
nt = size(dat,1);
nlls = zeros(1,nt);
v_right=0.5;
v_left=0.5;
beta = xpar(2);
gamma = mean([xpar(1), xpar(3)]);
omega = xpar(5);
c_right = .5;
c_left = .5;
for k=1:nt
    q_right = v_right + c_right*omega;
    q_left = v_left + c_left*omega;
    [pleft,pright] = DecisionRule(q_left,q_right,beta);
    [nlls(k), negloglike] = NegLogLike(pleft,pright,dat(k,1),negloglike);
    [v_left, v_right, rpe] = IncomeUpdateStep(dat(k,2),dat(k,1),v_left,v_right,xpar);
    c_right = update(c_right, gamma, dat(k,1)==1);
    c_left = update(c_left, gamma, dat(k,1)==-1);
end
end