function y = call_genertator(x ,t)
p = exp(-x*t)*x*t ;
if(rand <= p )
    y = 1 ;
else
    y= 0;
end


