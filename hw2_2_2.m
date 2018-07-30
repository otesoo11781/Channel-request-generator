%HW2 ,Question 2.(2)
clear all ;
base_lambda = 1 ;
base_service = 0.2 ;
channel = [5 5 5 5 5 5 5 5 5 5 5 5] ;
total_request(12) = 0 ;
total_block(12) = 0 ;
R = zeros(12 , 20000) ;
borrow = [3 1;
          3 2;
          3 3;
          4 4;
          5 5;
          4 5;
          8 9;
          8 8;
          8 9;
          10 10;
          10 12;
          10 12;];
borrow_num = zeros(12 , 2) ;
for i = 1:12
    lambda(i) = (mod(i , 4) + 1 ) *  base_lambda;
    service(i) = (mod(i , 4) + 1 ) *  base_service;
end

for i = 1:10000
    for j = 1:12
        if(R(j , i) >= 1)
            channel(j) = channel(j) + R(j , i) ;
            if(borrow_num(j , 1) > 0 )
                 if( R(j , i) - borrow_num(j , 1) >= 0 )
                    channel(borrow(j,1)) = channel(borrow(j,1)) + borrow_num(j , 1) ;
                     borrow_num(j , 1) = 0 ;
                    R(j , i) = R(j , i) - borrow_num(j , 1);
                 else
                     channel(borrow(j,1)) = channel(borrow(j,1)) + R(j , i) ;
                     borrow_num(j , 1) = borrow_num(j , 1) - R(j , i) ;
                     R(j , i ) = 0 ;
                 end
            end
            if(borrow_num(j , 2) > 0)
                if( R(j , i) - borrow_num(j , 2) >= 0 )
                    channel(borrow(j,2)) = channel(borrow(j,2)) + borrow_num(j , 2) ;
                    borrow_num(j , 2) = 0 ;
                    R(j , i) = R(j , i) - borrow_num(j , 2);
                else
                     channel(borrow(j,2)) = channel(borrow(j,2)) + R(j , i) ;
                     borrow_num(j , 2) = borrow_num(j , 2) - R(j , i) ;
                     R(j , i ) = 0 ;
                 end
            end
        end
    end
    for j = 1:12
        y(j ,i) = call_generator(lambda(j), 0.01) ;
        if(y(j ,i) == 1 )
           if(channel(j) > 0)
             channel(j) = channel(j) - 1 ;
             block(j , i) = 0 ;
             t = -log(rand) / (service(j)*0.01) ;
             R(j ,i +ceil(t) ) = R(j ,i +ceil(t) ) + 1;
           else
                block(j , i) = 1 ;
                total_block(j ) = total_block(j) + 1;
           end
            total_request(j) = total_request(j) + 1 ;
        end     
    end
   for j = 1:12
        if(y(j , i) == 1 && block(j , i) == 1)
            if(channel(borrow(j ,1 )) > 0 | channel(borrow(j ,2) ) >0  )
                     if(channel(borrow(j , 1)) > channel(borrow(j , 2)))
                        channel(j) = channel(j) - 1 ;
                         channel(borrow(j , 1)) = channel(borrow(j , 1)) - 1;
                         t = -log(rand) / (service(j)*0.01) ;
                         R(j ,i +ceil(t) ) = R(j ,i +ceil(t) ) + 1;
                         borrow_num(j ,1) = borrow_num(j , 1) + 1 ; 
                         block(j , i) = 0 ;
                         total_block(j) = total_block(j) - 1;
                     else
                        channel(j) = channel(j) - 1;
                        channel(borrow(j , 2)) = channel(borrow(j , 2)) - 1;
                        t = -log(rand) / (service(j)*0.01) ;
                        R(j ,i +ceil(t) ) = R(j ,i +ceil(t) ) + 1;
                        borrow_num(j , 2) = borrow_num(j , 2) + 1;
                        block(j , i) = 0 ;
                        total_block(j) = total_block(j) - 1;
                     end
             else
                 block(j , i) = 1 ;
            end  
        end
   end
end
for j = 1:12
    blocking_probability(j) = total_block(j) / total_request(j) ;
    sprintf('Blocking probability of BS%d : %.4g ' , j , blocking_probability(j)) 
end
ABP = 0 ;
for j = 1:12
    ABP = ABP + blocking_probability(j) ;
end
ABP = ABP / 12 