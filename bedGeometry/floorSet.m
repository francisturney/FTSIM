% Function: floorSet
% Definition: Sets the jth particle between the floor and the particle it's touching
% Inputs : Particle array and index of the particle you want to set between
% the floor and it's neighbor

function particleArray = floorSet(particleArray,j)                       % Set the particle on floor
import bedGeometry.*                                                     % Package of functions controlling bed Geometry

    P = particleArray;                                                   % Simplify notation
    jthParticle = particleArray(j);                                      % ...
    touch = jthParticle.touching;                                        % ... 
    x = 0;                                                               % Assin a dummy x that will be assigned to P(i).x later on
    if jthParticle.LR == 1
        x = (P(touch).x + sqrt((P(touch).r + P(j).r).^2 - (P(j).r - P(touch).z).^2)); %intersection of y = r and circle
    else
        x = (P(touch).x - sqrt((P(touch).r + P(j).r).^2 - (P(j).r - P(touch).z).^2)); %intersection of y = r and circle 
    end
    z = P(j).r;
    P(j).z = z;                         % Set z coordinate
    P(j).x = x;                         % Set x coordinate
    P(j).center=[x,z];                  % Set Center
    
    %move(particleArray,j,x,z);
end