function touching = rawTouching(particleArray,i)
  import bedGeometry.*                                      % Package of functions controlling bed Geometry
    global nParticles
    global nDummies
    P = particleArray;
    touching = 0;
    for j=(nParticles + nDummies):-1:1                                          % Check if particles touching starting with last  
        jnotPlaced = @(i,j) (j >= i) && (j <= 50);
          % Exclusions
          if  (j == 0) || jnotPlaced(i,j) || (j == i)  % Don't consider the particles that the jth Particle
                continue
          end                                                                     % have already been placed against
          if pdist([P(i).center; P(j).center],'euclidean') <= (P(i).r + P(j).r) %If distance between particles is less than the
              touching = touching + 1    
          end                                         %the sum of radii then they are touching
    end
end