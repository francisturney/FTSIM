%alertate find min particle
           for j=1:(i-1)                           % j particle is closest particle to rst on
                if (j == Max) || (j == 0);
                    continue;
                end
                if (right) && (P(j).x > P(Max).x)
                    j
                    right
                    P(j).x
                    P(Max).x
                    if pdist([P(j).center; P(Max).center],'euclidean') < (P(Max).r + 2*P(i).r + P(j).r)    %If particle i sits between particle m and particle j
                       j;
                       d(j) = pdist([P(i).center; P(j).center],'euclidean') - P(j).r - P(i).r;                            %enter distance into distance vector
                       min(d)
                       if d(j) == min(d)
                           Q = P;
                           Q = place(Q,i,j,Max);
                           if touching(Q,i,Max) == 0                            
                                fprintf('in search right\n')
                                j
                                Min=j
                           end
                       end
                    end
                else if (right == false) && (P(j).x < P(Max).x)
                    if pdist([P(j).center; P(Max).center],'euclidean') < (P(Max).r + 2*P(i).r + P(j).r)    %If particle i sits between particle m and particle j
                       d(j) = pdist([P(i).center; P(j).center],'euclidean') - P(j).r - P(i).r;                            %enter distance into distance vector
                       if d(j) == min(d)
                           Q = P;
                           Q = place(Q,i,j,Max);
                           if touching(Q,i,Max) == 0 
                                fprintf('in search left\n')
                                Min=j
                                pause
                           end
                       end
                    end
                    end           
                end
           end