% IsTouching
% Inputs : Particle Array, and index of the particle you're interested in (j). 
% Outputs : Index of the particle that the jth particle is touching (touching). 
    % If the jth particle is touching more than one particle it returns the 
    % particle with the highest index.
    
function touching = isTouching(particleArray,i)           
    import bedGeometry.*                                      % Package of functions controlling bed Geometry
    global nParticles
    global nDummies
    P = particleArray;
    touching = 0;
    for j=(nParticles + nDummies):-1:1                                          % Check if particles touching starting with last  
        jnotPlaced = @(i,j) (j >= i) && (j <= 50);
          % Exclusions
          if (j == P(i).touching) || (j == 0) || (j == P(i).prevTouch) || jnotPlaced(i,j) || (j == i) % || (j == P(i).landing)  % Don't consider the particles that the jth Particle
                continue
          end                                                                     % have already been placed against
          if pdist([P(i).center; P(j).center],'euclidean') <= (P(i).r + P(j).r) %If distance between particles is less than the
              touching = j;    
              return
          end                                         %the sum of radii then they are touching
    end
end
           