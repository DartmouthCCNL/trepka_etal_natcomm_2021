function dec_array = binary_to_decimal(binary_mtx)
dec_array = zeros(size(binary_mtx, 1), 1);
for i=1:size(binary_mtx,1)
    dec = 0;
    len = size(binary_mtx, 2);
    for p = 1:len
        dec = dec + binary_mtx(i,p)*(2^(len-p));
    end
    dec_array(i) = dec;
end
end