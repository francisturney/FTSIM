% Function: assnPivot
% Description: Find the particle and point around which each top particle pivots, and then
% assign moment arms.

function assnPivot(particleArray)  
    global nParticles
    global nDummies
    import bedGeometry.*                                                % Package of functions controlling bed Geometry
    P = particleArray;                                                  % Simplify Notation
    
    for i=1:nParticles + nDummies
        if P(i).isCFM                              % Find Pivot Points for Canidates For Movement only
           pivotParticle = 0;                      % Index of the Particle that the jth particle pivots around
           
           % Assing Pivot Particle
           for j=2:nParticles + nDummies                                                       % Look at all particles that could touch
               if P(i).x < P(j).x                                          % Look only to the right of top particles
                   if pdist([P(i).center; P(j).center],'euclidean') <= (P(i).r + P(j).r +.05) % look for touching particle (.05 is an error term)
                       if pivotParticle == 0;                                                %if there was no other pivot particle
                           pivotParticle = j;
                       else if P(pivotParticle).z < P(j).z           %if there was other pivot particle then only use the highest one
                                pivotParticle = j;
                           end   
                       end
                   end  
               end
           end
           
           % Assign Pivot Point
           pivot = pivotParticle; % Simplify Notation
           
           theta = asin((P(pivot).x - P(i).x)/(P(pivot).r + P(i).r)); %Solving for angles between lever and forces 
           beta = acos((P(pivot).x - P(i).x)/(P(pivot).r + P(i).r));
           if P(i).z < P(pivot).z
                 P(i).pivotPoint = [P(i).x + P(i).r*sin(theta),P(i).z + P(i).r*sin(beta)];
           else
                 P(i).pivotPoint = [P(i).x + P(i).r*sin(theta),P(i).z - P(i).r*sin(beta)];
           end
           
           % Assign Moment Arms
           P(i).gravityMomentArm = P(i).r*sin(theta);                                           % Moment arm is radius times angle between forces
           P(i).dragMomentArm = P(i).r*sin(beta);   
        end
    end
end