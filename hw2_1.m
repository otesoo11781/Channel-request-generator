%HW2 , Question 1.
clear all ;
recent_event = 0 ;
total_event = 0 ;
time(100000) = 0 ;
for i = 1:100000
    y(i) = call_generator(0.5 ,0.5) ;
    if(y(i) == 1)
        if(recent_event ~= 0)
            j = i - recent_event ;
            time(j) = time(j) + 1 ;
        end
        recent_event = i ;
        total_event = total_event + 1 ;
    end
end
time = time./total_event ;
i = 1:30 ;
plot(i*0.5, time(i)) ;
set(gca , 'xtick' , [0.5:1:15]);
grid on ;