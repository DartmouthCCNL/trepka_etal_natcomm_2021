function prob = conditional_probability(y,x)
% % conditional_probability %
%PURPOSE:   Compute conditional probability p(y|x) from two logical vectors 
%AUTHORS:   Ethan Trepka 10/05/2020

    prob = mean(y&x)/mean(x);
end