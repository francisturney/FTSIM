%alternate drop particle
    for j=1:(i-1)
        if abs(P(j).x - P(i).x) < (P(i).r + P(j).r)       %check to see what particles are in the parth of i
            v(j) = P(j).y + P(j).r;                                %log height above surface in v
             if v(j) == max(v)                          %keep track of the highest particle in v
                 Max=j;
             end
        end
    end
    if isequal(v,[])                                      %if nothing in path then land on the floor
        P(i).y = P(i).r;
        P(i).center = [P(i).x,P(i).y];
        viscircles(P(i).center,P(i).r);
        pause
    else                                                                           %if collision 
        P(i).y = P(Max).y + abs(sqrt((P(i).r + P(Max).r)^2 - (P(i).x - P(Max).x)^2)); %move y to position 
        P(i).center = [P(i).x,P(i).y];
        viscircles(P(i).center,P(i).r);
        pause
