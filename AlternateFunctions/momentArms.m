% Function: momentArms
% Description: Calculate Moment Arms and Assign Pivot Points

function momentArms(P,nParticles)  
import bedGeometry.*                                            % Package of functions controlling bed Geometry

    theta = 0;                                                  % Theta is the angle between gravity force and lever arm
    beta = 0;                                                   % Beta is the angle between drag force and lever arm
    for i=1:nParticles
            if P(i).isTop
                theta = asin((P(P(i).pivotParticle).x - P(i).x)/(P(P(i).pivotParticle).r + P(i).r)); %Solving for angles between lever and forces 
                beta = acos((P(P(i).pivotParticle).x - P(i).x)/(P(P(i).pivotParticle).r + P(i).r));  
                P(i).gravityMomentArm = P(i).r*sin(theta);                                           % Moment arm is radius times angle between forces
                P(i).dragMomentArm = P(i).r*sin(beta);                        
                if P(i).y < P(P(i).pivotParticle).y
                    P(i).pivotPoint = [P(i).x + P(i).r*sin(theta),P(i).y + P(i).r*sin(beta)];
                else
                    P(i).pivotPoint = [P(i).x + P(i).r*sin(theta),P(i).y - P(i).r*sin(beta)];
                end
            end
    end
end