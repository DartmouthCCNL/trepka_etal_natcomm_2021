function my_text = render_p_and_d_value(p, d)
if ~exist('d', 'var')
        exponent = floor(log10(p));
    base = p * (10^(-exponent));
    my_text = sprintf("p = %1.2f*10^%d", base, exponent); 
else
    exponent = floor(log10(p));
    if exponent<-2
        base = round(p * (10^(-exponent))*100)/100;
        my_text = sprintf("$p = %1.2f*10^{%d}$    $d = %1.2f$", base, exponent, d); 
    else
        base = round(p*100)/100;
        my_text = sprintf("$p = %1.2f$       $d = %1.2f$", base, d); 
    end
end
end