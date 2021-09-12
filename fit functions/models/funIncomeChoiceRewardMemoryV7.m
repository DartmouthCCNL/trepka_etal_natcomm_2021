function [negloglike, nlls]=funIncomeChoiceRewardMemoryV7(xpar,dat)
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
omega = xpar(5);
omega1 = xpar(6);
gamma = xpar(7);

%omega1 = xpar(6);
c_right = .5;
c_left = .5;
        delta_right = 0;
        delta_left = 0;
        stay_bias_right = 0;
stay_bias_left = 0;
erpe = .5;
for k=1:nt
    q_right = v_right + delta_right;
    q_left = v_left + delta_left;
    [pleft,pright] = DecisionRule(q_left,q_right,beta);
    [nlls(k), negloglike] = NegLogLike(pleft,pright,dat(k,1),negloglike);
    [v_left, v_right, rpe] = IncomeUpdateStep(dat(k,2),dat(k,1),v_left,v_right,xpar);
    c_right = update(c_right, gamma, dat(k,1)==1);
    c_left = update(c_left, gamma, dat(k,1)==-1);
    erpe = update(erpe, gamma, abs(rpe));
    stay_bias_right = (dat(k,2)*2-1)*(dat(k,1)==1);
    stay_bias_left = (dat(k,2)*2-1)*(dat(k,1)==-1);
    if dat(k,2)<1
        delta_right =  erpe*stay_bias_right*omega1 + (c_right*omega);
        delta_left = erpe*stay_bias_left*omega1 + (c_left*omega);
    else
        delta_right = c_right*omega;
        delta_left = c_left*omega;
    end
end
end