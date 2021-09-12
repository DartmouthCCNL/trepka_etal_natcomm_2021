function output = nansem(input)
    output = nanstd(input)/sqrt(sum(~isnan(input), 'all'));
end