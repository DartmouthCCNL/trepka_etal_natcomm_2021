function my_text = render_p_and_d_value_combined(p, d, p2, d2)
if ~exist('d', 'var')
    exponent = floor(log10(p));
    base = p * (10^(-exponent));
    my_text = sprintf("p = %1.2f*10^%d", base, exponent);
else
    exponent = floor(log10(p));
    exponent2 = floor(log10(p2));
    
    if exponent<-2 && exponent2<-2
        base = round(p * (10^(-exponent))*100)/100;
        base2 = round(p2 * (10^(-exponent2))*100)/100;
        if d<0
            my_text = sprintf("$p = %1.2f*10^{%d}\\quad\\quad p = %1.2f*10^{%d}$\n$d = %1.2f\\quad\\quad\\quad\\quad d = %1.2f$", base, exponent, base2, exponent2, d, d2);
        else
            my_text = sprintf("$p = %1.2f*10^{%d}\\quad\\quad p = %1.2f*10^{%d}$\n$d = %1.2f\\quad\\quad\\quad\\quad\\quad d = %1.2f$", base, exponent, base2, exponent2, d, d2);
        end
    elseif exponent<-2
        base = round(p * (10^(-exponent))*100)/100;
        base2 = round(p2*100)/100;
        if d<0
            my_text = sprintf("$p = %1.2f*10^{%d}\\quad\\quad p = %1.2f$\n$d = %1.2f\\quad\\quad\\quad\\quad d = %1.2f$", base, exponent, base2, d, d2);
        else
            my_text = sprintf("$p = %1.2f*10^{%d}\\quad\\quad p = %1.2f$\n$d = %1.2f\\quad\\quad\\quad\\quad\\quad d = %1.2f$", base, exponent, base2, d, d2);
            
        end
    elseif exponent2<-2
        base = round(p*100)/100;
        base2 = round(p2 * (10^(-exponent2))*100)/100;
        if d<0
            my_text = sprintf("$p = %1.2f\\quad\\quad\\quad\\quad\\quad p = %1.2f*10^{%d}$\n$d = %1.2f\\quad\\quad\\quad\\quad d = %1.2f$", base, base2, exponent2, d, d2);
        else
            my_text = sprintf("$p = %1.2f\\quad\\quad\\quad\\quad\\quad p = %1.2f*10^{%d}$\n$d = %1.2f\\quad\\quad\\quad\\quad\\quad d = %1.2f$", base, base2, exponent2, d, d2);
            
        end
    else
        base = round(p*100)/100;
        base2 = round(p2*100)/100;
        if d<0
            my_text = sprintf("$p = %1.2f\\quad\\quad p = %1.2f$\n$d = %1.2f\\quad\\quad\\quad\\quad d = %1.2f$", base, base2, d, d2);
        else
            my_text = sprintf("$p = %1.2f\\quad\\quad p = %1.2f$\n$d = %1.2f\\quad\\quad\\quad\\quad\\quad d = %1.2f$", base, base2, d, d2);
            
        end
    end
end
end