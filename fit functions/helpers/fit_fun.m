function [qpar, negloglike, bic, nlike, aic]=fit_fun(stats,fit_fun,initpar,lb,ub)    
% % fit_fun %
%PURPOSE:   Fit the choice behavior to a model using maximum likelihood estimate
%AUTHORS:   AC Kwan 170518, Ethan Trepka 210220
%
%INPUT ARGUMENTS
%   stats:      stats of the game
%   fit_fun:    the model to fit, e.g., Q_RPEfun
%   initpar:    initial values for the parameters
%   lb:         lower bound values for the parameters (if used)
%   ub:         upper bound values for the parameters (if used)
%
%OUTPUT ARGUMENTS
%   qpar:       extracted parameters
%   negloglike: negative log likelihood
%   bic:        Bayesian information criterion
%   nlike:      normalized likelihood

%%
maxit=1e7;
maxeval=1e7;
op=optimset('fminsearch');
op.MaxIter=maxit;
op.MaxFunEvals=maxeval;

func_handle = str2func(fit_fun);
if ~exist('lb','var')
    [qpar, negloglike, exitflag]=fminsearch(func_handle, initpar, op, [stats.c stats.r]);
else
    [qpar, negloglike, exitflag]=fmincon(func_handle, initpar, [], [], [], [], lb, ub, [], op, [stats.c stats.r]);
end
if exitflag==0
    qpar=nan(size(qpar));   %did not converge to a solution, so return NaN
    negloglike=nan;
end

%% BIC, bayesian information criterion
%BIC = -2*logL + klogN
%L = negative log-likelihood, k = number of parameters, N = number of trials
%larger BIC value is worse because more parameters is worse, obviously
bic = 2*negloglike + numel(initpar)*log(sum(~isnan(stats.c)));

%% AIC, Aikake information crieterion
%AIC = -2*logL + 2k
%L = negative log-likelihood, k = number of parameters
aic = 2*negloglike + numel(initpar)*2;

%% Normalized likelihood 
%(Ito and Doya, PLoS Comp Biol, 2015)
nlike = exp(-1*negloglike)^(1/sum(~isnan(stats.c)));

end
