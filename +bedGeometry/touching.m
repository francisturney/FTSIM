function touching = touching(particleArray,j)             % Determines if the jth particle is touching any others in the array and returns the index of the particle it touches
import bedGeometry.*                                      % Package of functions controlling bed Geometry
jthParticle = particleArray(j);                           % Easier to read notation

    touching = 0;
    for k=(j-1):-1:1                                        % Check if particles touching starting with last
        kthParticle = particleArray(k);                     % Easier to read notation                                           
          if ((k == jthParticle.touch) || (k == 0)) || (k == jthParticle.prevTouch)   % Don't consider the particles that the jth Particle
                continue                                                              % have already been placed against
          end
              if pdist([jthParticle.center; kthPaticle.center],'euclidean') <= (jthPaticle.r + kthParticle.r) %If distance between particles is less than the
                  touching = k;                                                                               %the sum of radii then they are touching 
                  return
              end         
    end
end
           