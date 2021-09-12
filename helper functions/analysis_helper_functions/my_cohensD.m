function output = my_cohensD(input1, input2)
    pooledSD = sqrt((nanstd(input1)^2+nanstd(input2)^2)/2);
    output = (nanmean(input1)-nanmean(input2))/pooledSD;
end