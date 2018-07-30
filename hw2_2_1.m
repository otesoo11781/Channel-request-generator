%HW2 , Question 2.(1) , ABP = Average Blocking Probability
clear all ;
base_lambda = 1 ;
base_service = 0.2 ;
channel = [5 5 5 5 5 5 5 5 5 5 5 5] ;
total_request(12) = 0 ;
total_block(12) = 0 ;
R = zeros(12 , 20000) ;
for i = 1:12
    lambda(i) = (mod(i , 4) + 1 ) *  base_lambda;
    service(i) = (mod(i , 4) + 1 ) *  base_service;
end

for i = 1:10000
    for j = 1:12
        if(R(j ,i) >= 1)
            channel(j) = channel(j) + R(j ,i) ;
        end
        y(j ,i) = call_generator(lambda(j), 0.01) ;
        if(y(j ,i) == 1 )
           if(channel(j) > 0)
             channel(j) = channel(j) - 1 ;
             block(j , i) = 0 ;
             t = -log(rand) / (service(j)*0.01) ;
             R(j ,i +ceil(t) ) = R(j ,i +ceil(t) ) + 1;
         else
             block(j ,i) = 1 ;
             total_block(j) = total_block(j) + 1 ;
            end
            total_request(j) = total_request(j) + 1 ;
        end
    end
end
for j = 1:12
    blocking_probability(j) = total_block(j) / total_request(j) 
end
ABP = 0 ;
for j = 1:12
    ABP = ABP + blocking_probability(j) ;
end
ABP = ABP / 12 