function reverse = reversed(particleArray,j)               %HAS THE PARTICLE REVESED ITS ROLL? 
import bedGeometry.*        % Package of functions controlling bed Geometry

   reverse = false;                               %Particle i is on which side of particle Max 
   switch  whichSide(particleArray,j) 
        case 1                                    %if P(i) is right of P(Max)
            if particleArray(j).LR == -1                            %but was left
                reverse = true;                   %TERMINATE find position
            end
        case -1                                   %if P(i) is left of P(Max)
            if particleArray(j).LR == 1                             %but was right
                reverse = true;                   %TERMINATE find position
            end    
   end
end