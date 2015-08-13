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

function solveUft(particleArray,Cd,k,mu,rhoAir,rhoSand,g,z0,ave)
        global nParticles
        global nDummies
        global aveCFM
        P = particleArray;                     % Simplify Notation    
        
    for i=1:nParticles + nDummies
        if P(i).isCFM
            % Simplify and Declare
            I = 0;                                          % Integral of wind speed and particle area from equation (5) 
            zCenter = P(i).z - ave;                         % z coordinate of the center of the particle with the average height as z = 0 
            zLift = P(i).liftPoint(2) - ave;                % z coordinate of the lift point with the average height as z = 0
            zTop = (zCenter + P(i).r);                      % z coordinate of the top of the ith particle
            rG = P(i).gravityMomentArm;                     % Simplify Notation
            rD = P(i).dragMomentArm;                        % Simplify Notation
            s = 1;                                          % Scale factor for differently sized grains
            c = s*10000;                                    % (conversion coeficient between hundreds of microns, the assumed model scale (particle radius untis), and meters)
            
            
            % Drag force integration
            % Logrithmic wind profile          
                f = @(z) (log(z./z0)).^2.*(sqrt(P(i).r.^2 - (zCenter - z).^2));     % Integrand for I (equation (5)) figure (1)                                   
                if P(i).liftPoint(2) > ave + z0;                                    % If the lift point is above the average height of top row (u = 0)
                    I = integral(f, zLift, zTop);                                   % numerically integrate from liftPoint to top of Particle
                else                                                                % If the lift point is below the average height of the top row 
                    I = integral(f, z0, zTop);                                       % numerical integrate from z0 (u = 0), to the top of particle 
                end
                % Solve for threshold shear velocity by substituting of values into equation (8) 
                P(i).uft = sqrt((pi*(rhoSand - rhoAir)*g*((P(i).r*2/c)^3)*(k^2)*rG)/(12*rhoAir*rD*Cd*(I/(c^2))));
                P(i).I(1) = I; % Save integral
                
            % Linear Wind Profile
                f = @(z) z.^2.*(sqrt(P(i).r.^2 - (zCenter - z).^2));                % Integrand for I (equation (5)) figure (1)                                   
                if P(i).liftPoint(2) > ave;                                         % If the lift point is above the average height of top row (u = 0)
                    I = integral(f, zLift, zTop);                                   % numerically integrate from liftPoint to top of Particle
                else                                                                % If the lift point is below the average height of the top row 
                    I = integral(f, 0, zTop);                                     % numerical integrate from z0 (u = 0), to the top of particle 
                end
                P(i).uft(2) = nthroot((pi*(rhoSand - rhoAir)*g*((P(i).r*2/c)^3)*(mu^2)*rG)/(12*(rhoAir^3)*rD*Cd*(I/(c^2))),4);
                P(i).I(2) = I; % Save integral
                
            % Include wakes
                wake = 0;
                wakeArray = []; % Canidates for being a wake particle and their respective indicies 
                for j=1:nParticles + nDummies
                    if (P(j).x < P(i).x) && ((P(i).z) < (P(j).z + P(j).r))... %&& ((P(j).z + P(j).r) > aveCFM) ...
                            && ((P(i).x - P(j).x) < 20*P(i).r)   % if upstream, in fluid path less than 10 particles away
                        P(j).ld = (P(i).x - P(j).x);            % Length between wake and ith particle
                        P(j).hp = (P(j).z + P(j).r - (P(i).z));
                        wakeArray(j) = P(j).ld/P(j).hp;
                    else 
                        wakeArray(j) = 2000;
                    end
                end   
                [Min,wake] = min(wakeArray);
                if Min ~= 2000;
                   P(i).wake = wake;
                end

             % Modified logrithmic profile
                if P(i).wake ~= 0;
                    f = @(z) (log(z./z0).*erf((P(wake).ld - 1.5.*P(wake).hp)./(5.*P(wake).hp))).^2.*(sqrt(P(i).r.^2 - (zCenter - z).^2));     % Integrand for I (equation (5)) figure (1)    
                else
                    f = @(z) (log(z./z0)).^2.*(sqrt(P(i).r.^2 - (zCenter - z).^2));     % Integrand for I (equation (5)) figure (1)
                end
                if P(i).liftPoint(2) > ave + z0;                                    % If the lift point is above the average height of top row (u = 0)
                    I = integral(f, zLift, zTop);                                   % numerically integrate from liftPoint to top of Particle
                else                                                                % If the lift point is below the average height of the top row 
                    I = integral(f, z0, zTop);                                       % numerical integrate from z0 (u = 0), to the top of particle 
                end
                
                % Solve for threshold shear velocity by substituting of values into equation (8) 
                P(i).uft(3) = sqrt((pi*(rhoSand - rhoAir)*g*((P(i).r*2/c)^3)*(k^2)*rG)/(12*rhoAir*rD*Cd*(I/(c^2))));
                P(i).I(3) = I; % Save integral
                
             % Modified linear wind Profile
                if P(i).wake ~= 0;
                    f = @(z) (z.*erf((P(wake).ld - 1.5.*P(wake).hp)./(5.*P(wake).hp))).^2.*(sqrt(P(i).r.^2 - (zCenter - z).^2));                % Integrand for I (equation (5)) figure (1)                 
                else
                    f = @(z) z.^2.*(sqrt(P(i).r.^2 - (zCenter - z).^2));  
                end
                if P(i).liftPoint(2) > ave;                                         % If the lift point is above the average height of top row (u = 0)
                    I = integral(f, zLift, zTop);                                   % numerically integrate from liftPoint to top of Particle
                else                                                                % If the lift point is below the average height of the top row 
                    I = integral(f, 0, zTop);                                     % numerical integrate from z0 (u = 0), to the top of particle 
                end
                P(i).uft(4) = nthroot((pi*(rhoSand - rhoAir)*g*((P(i).r*2/c)^3)*(mu^2)*rG)/(12*(rhoAir^3)*rD*Cd*(I/(c^2))),4);
                P(i).I(4) = I; % Save integral
                
            % Solved Linear Wind Profile
%                 if P(i).liftPoint(2) > ave;                                         % If the lift point is above the average height of top row (u = 0)
%                     I = zTop - zLift - (1/P(i).r)*((zCenter - zLift)^2 - (zCenter - zTop)^2)...
%                         + (1/3)*((zCenter - zTop)^3 - (zCenter - zLift)^3);                                   % numerically integrate from liftPoint to top of Particle
%                 else                                                                % If the lift point is below the average height of the top row 
%                     I = zTop - z0 - (1/P(i).r)*((zCenter - z0)^2 - (zCenter - zTop)^2)...
%                         + (1/3)*((zCenter - zTop)^3 - (zCenter - z0)^3);                                            % numerical integrate from z0 (u = 0), to the top of particle 
%                 end
%                 P(i).uft(3) = nthroot((pi*(rhoSand - rhoAir)*g*((P(i).r*2/c)^3)*(mu^2)*rG)/(12*(rhoAir^3)*rD*Cd*(I/(c^2))),4);   
%                
            
         end

     end
end
