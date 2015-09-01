% Function: assnPivot
% Description: Find the particle and point around which each top particle pivots, and then
% assigns moment arms.

function P = assnPivot(P, nParticles)  
    import bedGeometry.*                                                                       % Package of functions controlling bed Geometry                                                                         % Simplify Notation
    nDummies = 2*nParticles;
    
    for i=1:nParticles + nDummies
        if P(i).isCFM                                                                          % Find Pivot Points for Canidates For Movement only
           P(i).pivot = 0;                                                                  % Index of the Particle that the ith particle pivots around
           c = 0;                                                                           % Distance between contact points for law of cosines see Force Diagram  
           
           % Assining Pivot Particle
           for j=2:nParticles + nDummies                                                       % Look at all particles that could touch
               if P(i).x < P(j).x                                                              % Look only to the right of top particles
                   if pdist([P(i).center; P(j).center],'euclidean') <= (P(i).r + P(j).r +.05)  % look for touching particle (.05 is an error term)
                       if P(i).pivot == 0;                                                  % If there was no other pivot particle
                           P(i).pivot = j;
                       else if P(P(i).pivot).z < P(j).z                                     % If there was other pivot particle then only use the highest one
                                P(i).pivot = j;
                           end   
                       end
                   end  
               end
           end
           
           % Assign Pivot Point
           pivot = P(i).pivot;                                                             % Simplify Notation
           
           P(i).theta = asin((P(pivot).x - P(i).x)/(P(pivot).r + P(i).r));                         % Solving for angles between lever and forces see Force Diagram in methods of FTSIM paper
           P(i).beta = pi/2 - P(i).theta;                                                              % alternativly acos((P(pivot).x - P(i).x)/(P(pivot).r + P(i).r))
           
           P(i).pivotPoint = [P(i).x + P(i).r*sin(P(i).theta),P(i).z - P(i).r*sin(P(i).beta)];
          
           % Assign Moment Arms                    
           P(i).gravityMomentArm = P(i).r*sin(P(i).theta);                                        % Moment arm is radius times angle between forces
           P(i).dragMomentArm = P(i).r*sin(P(i).beta);  
           
            % Assign Cohesive Force Moment arm
               c = pdist([P(i).liftPoint; P(i).pivotPoint],'euclidean');                         % Distance between contact points for law of cosines
               P(i).gamma = acos((2.*P(i).r.^2 - c^2)/(2*P(i).r.^2));                            % Law of cosines to figure out angle between cohesive force and lever arm
               P(i).cohesiveMomentArm = P(i).r*sin(P(i).gamma);
           
        end
    end
end