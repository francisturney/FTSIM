% Function: idTop
% Description: Identify Top Layer of particles by droping dummy particles and assuming
% the particles they collide with are on top.

function idTop(particleArray,i,nParticles,nDummies,lBound,range)
    P = particleArray(i,:);
    import bedGeometry.*                                                 % Package of functions controlling bed Geometry
    
    for i=1:nParticles + nDummies                                               % reset top
      P(i).isTop = false;
        nAbove = 0;                             % Particles above P(i)
        per = 0;
        iRight = P(i).x + P(i).r;           % Boundaries of P(i)'s and P(j)'s projection on the x-axis
        iLeft = P(i).x - P(i).r;
        for j=1:nParticles + nDummies
            if j==i; continue; end
            jRight = P(j).x + P(j).r;
            jLeft = P(j).x - P(j).r;
            if (iLeft < jRight) && (jLeft < iRight) && (P(i).z < P(j).z)     % If the two lines are not overlapping
                %nAbove = nAbove + 1;         % Number of particles above
                if iLeft < jLeft
                    per = per + abs(iRight - jLeft)/(2*P(i).r);
%                     if abs(iRight - jLeft)/(2*P(i).r) > 0.6 % If P(j) overlaps P(i) by more than 50%
%                         nAbove = nAbove + 1;
%                         % break
%                     end
                else
                    per = per + abs(jRight - iLeft)/(2*P(i).r);
%                     if abs(jRight - iLeft)/(2*P(i).r) > 0.6 % If P(j) overlaps P(i) by more than 50%
%                         nAbove = nAbove + 1;
%                         % break
%                     end
                end
            end
        end
        if nAbove < 3 && (P(i).x > lBound) && (P(i).x < (lBound + range)) && (per < 0.98) 
            P(i).isTop = true;
        end
    end
   return
    for i=(lBound + 5):2:(lBound + range - 5)
        top = false;                                                 
        for z = 55:-2:0 
            for j=1:nParticles + nDummies
                if (pdist([[i,z]; particleArray(j).center],'euclidean') <= (particleArray(j).r + 2))    % If collision with bed
                   particleArray(j).isTop = true;                               
                   top = true;  
                end
            end
            if top                                                  % If you found a top particle stop
                break;
            end
        end
    end
end