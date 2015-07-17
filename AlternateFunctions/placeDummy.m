% DESCRIPTION: Places jth particle in between the particle it's touching and the particle its landing on.
% Uses the fact that the center of jth particle is at the intersection of two circes, one centered at the
% touching particle and one centered at the landing particle, both with radii of the their respective
% particles plus the radius of the jth particle

function placeDummy(particleArray,j)                                        
    import bedGeometry.*                  % Package of functions controlling bed Geometry
     
     P = particleArray;                         % Simplify notation for complex calculation
     jthParticle = particleArray(j);            % ...
     touch = particleArray(j).touching;         % ...
     land = particleArray(j).landing;           % ...
     r1 = P(touch).r + P(j).r;                  % r of circle one                               
     r2 = P(land).r + P(j).r;                   % r of circle two 
     
     % SUBSTITUTE VARIABLES
     a = ((r2.^2 - r1.^2) - (P(land).x.^2 - P(touch).x.^2) - (P(land).z.^2 - P(touch).z.^2))/(P(touch).x - P(land).x);
     b = (P(touch).z - P(land).z)/(P(touch).x - P(land).x);
     c1 = b.^2 + 1;
     c2 = -(2*P(touch).z + a*b - 2*b*P(touch).x);
     c3 = P(touch).x.^2 - a*P(touch).x + P(touch).z.^2 + (1/4)*a.^2 - r1.^2;
     % SOLVE
     f = [c1 c2 c3];
     roots(f);
     P(j).z = max(roots(f));
     P(j).x = (1/2)*(a-2*b*P(j).z); 
     P(j).center = [P(j).x, P(j).z];
end