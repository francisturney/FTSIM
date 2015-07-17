% Function : initializeBed
% Description : Initializes particle bed one , first by droping, and then rotating around subsequent
% collided particles to find final position upon rotation reversal.
% Input : Particle Array and index of the particle you want to set in the bed (j)

function setParticle(particleArray,j)
    % Setup
    import bedGeometry.*                              % Package of functions controlling bed Geometry                                                                                       
    jthParticle = particleArray(j);                   % Simplify Notation
    
    % Drop and Allign
    drop(particleArray,j);                            % Move particle towards floor while gathering touched particle indicies and aligning
    if jthParticle.touching == 0                      % f particle j is not touching anyone after drop than it is on the ground                              
        return                                        % no need to contine if your on the ground
    end
    
    % Allign With Multiple Particles
    jthParticle.prevTouch = jthParticle.landing;           % Denote landing particle as previously touching to allign with multiple particles
    while isTouching(particleArray,j) > 0                  % If particle is touching multiple others after intial drop and allignment
        jthParticle.landing = isTouching(particleArray,j); % Select an overlaping particle to land on, (counting backwards from nParticles)
        place(particleArray,j);                            % Place jth paticle between the particle it's touching and the particle it will land on
        jthParticle.prevTouch = jthParticle.landing;       % Save the particle you landed on 
    end
    
    % Rotate
    while (reversed(particleArray,j) == false)             % While particle doesn't reverse rotation
        notCollided = @(particleArray,j) isTouching(particleArray,j) == 0; %
        aboveGround = @(particleArray,j) jthParticle.y > jthParticle.r;
        
        while notCollided(particleArray,j) && aboveGround(particleArray,j) % While not touching other particles and within bounds
            rotate(particleArray,j);                                       % Rotate the jth Paticle around its touching particle
            jthParticle.landing = isTouching(particleArray,j);             % Declare landing partilce as the partice the jth particle rolls into
        end
        if jthParticle.landing == 0                            % If you rotated and y went below 0, then place between floor and touching particle
            floorSet(particleArray,j);                         % Set on floor
            break                                              % and terminate 
        end
        
        % Place Particle 
        place(particleArray,j);                                % Place jth particle between touching and landing particles
        jthParticle.prevTouch = jthParticle.landing;           % Denote landing particle as previously touching in case jth particle touches multiple particles
        while (isTouching(particleArray,j) > 0)                % If particle is overlapping others after placement place again
            jthParticle.landing = isTouching(particleArray,j);
            place(particleArray,j);
            jthParticle.prevTouch = jthParticle.landing;           % Denote landing particle as previously touching to allign with multiple particles
        end
        
        % Reset Properties
        jthParticle.prevTouch = jthParticle.touching;                   % Resest variables for next loop
        jthParticle.touching = jthParticle.landing;                     % Landing particle becomes touching particle
        jthParticle.landing = 0;
    end
end                                                             
    

