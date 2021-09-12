function mySum = nansum_zero_helper(myArr, dimension)
    mySum = nansum(myArr, dimension);
    shouldBeNaN = sum(isnan(myArr), 2) == size(myArr, 2);
    mySum(shouldBeNaN) = NaN; 
end