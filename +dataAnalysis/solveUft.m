% Function: solveUft
% Description: Calculate Fluid Threshold From Moment Balance of Drag and Gravity Forces
% Inputs:
% particleArray                Particle Bed
% Cd                           Drag Coeficient
% k                            Von Karmen constant
% rhoAir                       Density of air (kg/m^3) sea level from wikipedia
% rhoSand                      Density of quarts sand (kg/m^3)        
% g                            Acceleration due to gravity (m/s^2) by convention 
% z0                           Roughness Length 
% ave                          Average height of top layer of particles
% Numerical Integration is done using Using Global Adaptive Quadrature and Default Error Tolerances

function solveUft(particleArray,Cd,k,rhoAir,rhoSand,g,z0,ave)
        global nParticles
        global nDummies
        P = particleArray;                     % Simplify Notation    
        
    for i=1:nParticles + nDummies
        if P(i).isCFM
            % Simplify and Declare
            I = 0;                                                              % Integral of wind speed and particle area from equation (5) 
            zCenter = P(i).z - ave;                                             % z coordinate of the center of the particle with the average height as z = 0 
            zLift = P(i).liftPoint(2) - ave;                                    % z coordinate of the lift point with the average height as z = 0
            
            % Drag force integration
            f = @(z) (log(z./z0)).^2.*(sqrt(P(i).r.^2 - (zCenter - z).^2));     % Integrand for I (equation (5)) figure (1)                                   
            if P(i).liftPoint(2) > ave + z0;                                         % If the lift point is above the average height of top row (u = 0)
                I = integral(f, zLift, (zCenter + P(i).r));                     % numerically integrate from liftPoint to top of Particle
            else                                                                % If the lift point is below the average height of the top row 
                I = integral(f, z0, (zCenter + P(i).r));                        % numerical integrate from z0 (u = 0), to the top of particle 
            end

            % Solve for threshold shear velocity
            rG = P(i).gravityMomentArm;                     % Simplify Notation
            rD = P(i).dragMomentArm;                        % Simplify Notation
            s = 1;                                          % Scale factor for differently sized grains
            c = s*10000;                                  % (conversion coeficient between hundreds of microns, the assumed model scale (particle radius untis), and meters)
            
            % Substitute values into equation (8) 
            P(i).uft = sqrt((pi*(rhoSand - rhoAir)*g*((P(i).r*2/c)^3)*(k^2)*rG)/(12*rhoAir*rD*Cd*(I/(c^2))));
         end

     end
end
