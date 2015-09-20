% Function: assnAntiPivot
% Description: Assign Lift Particles and Create Lift Point 

function P = assnLift(particleArray, nParticles)
    nDummies = nParticles*2;
    import bedGeometry.*                                        % Package of functions controlling bed Geometry
    import particle
    theta = 0;                                                  % theta is the angle between gravity force and lever arm
    beta = 0;                                                   % beta is the angle between drag force and lever arm 
    P = particleArray;                                          % Simplify Notation
    
    for i=1:nParticles + nDummies
        if P(i).isCFM                                           % Find only the top particles
           liftParticle = 0;                                    % index of Particle that jth particle lifts off of
           
           % Assign Lift Particle
           for j=2:nParticles + nDummies                                                            %look at all particles that could touch
               if P(i).x > P(j).x                                               %look only to the right of top particles
                   if pdist([P(i).center; P(j).center],'euclidean') <= (P(i).r + P(j).r + 0.015) % look for touching particle (.05 is an error term)
                       if liftParticle == 0;                                   %if there was no other pivot particle
                           liftParticle = j;
                       else if P(liftParticle).z < P(j).z                      %if there was other pivot particle then only use the highest one
                           liftParticle = j;
                           end   
                       end
                   end  
               end
           end
           
           % Assign Lift Point
           lift = liftParticle;
           P(i).lift = lift;
           
           theta = asin((P(i).x - P(lift).x)/(P(lift).r + P(i).r)); %Solving for angles between lever and forces
           if ~isreal(theta)
               disp('error + correction')
               i
               pause
               theta = asin((P(i).x - P(lift).x)/(P(lift).r + P(i).r + 0.016));
           end
           %beta = acos((P(lift).x - P(i).x)/(P(lift).r + P(i).r));  
%            if P(i).z < P(lift).z
%                P(i).liftPoint = [P(i).x + P(i).r*sin(theta),P(i).z + P(i).r*cos(theta)];
%            else
               P(i).liftPoint = [P(i).x - P(i).r*sin(theta),P(i).z - P(i).r*cos(theta)];
%           end
        end
    end
end