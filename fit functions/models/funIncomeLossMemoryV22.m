function [negloglike, nlls]=funIncomeLossMemoryV22(xpar,dat)
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
omega1 = xpar(5);
gamma = mean([xpar(1), xpar(3)]);
stay_bias_right = 0;
stay_bias_left = 0;
erpe = .5;

for k=1:nt
    q_right = v_right +stay_bias_right*omega1;
    q_left = v_left +stay_bias_left*omega1;
    [pleft,pright] = DecisionRule(q_left,q_right,beta);
    [nlls(k), negloglike] = NegLogLike(pleft,pright,dat(k,1),negloglike);
    [v_left, v_right, rpe] = IncomeUpdateStep(dat(k,2),dat(k,1),v_left,v_right,xpar);
            erpe = update(erpe, gamma, abs(rpe));
    if dat(k,2)==0
        stay_bias_right = (dat(k,2)*2-1)*(dat(k,1)==1)*erpe;
        stay_bias_left = (dat(k,2)*2-1)*(dat(k,1)==-1)*erpe;
    else
        stay_bias_right = 0;
        stay_bias_left = 0;
    end
end

end