function [pleft, pright] = DecisionRule(v_left,v_right,beta)

pright=exp(beta*v_right)/(exp(beta*v_right)+exp(beta*v_left));
pleft=1-pright;

if pright==0
    pright=realmin;   % Smallest positive normalized floating point number, because otherwise log(zero) is -Inf
end
if pleft==0
    pleft=realmin;
end
end

