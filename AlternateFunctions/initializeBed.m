% Function : initializeBed
% Description : Initializes particle bed, first by droping, then rotating each particle around subsequent
% collied particles to find the final position upon rotation reversal.
% Input : Particle Array and number of particles in bed

function initializeBed(particleArray,nParticles)
    % Setup
    import bedGeometry.*                              % Package of functions controlling bed Geometry    
    import particle
    global nDummies;                           % Number of dummy particles for making periodic boundary conditions
    global terminate;                          % Terminates placement of particle
    nDummies = 0;                              % Start off with no dummies
    P = particleArray;                         % Simplify notation
    figure
    for i=1:nParticles
        % Debug
        if mod(i,5) == 0
           clf
           for j=1:(i-1)
               viscircles(P(j).center,P(j).r,'EdgeColor','b');   % debug
           end
           for j = 51:(nParticles + nDummies)
               viscircles(P(j).center,P(j).r,'EdgeColor','b');   % debug
           end
           pause;
        end
        
        % Simplify Notation/ Declare
        terminate = false;
        ithParticle = particleArray(i);                   % Simplify Notation
        fprintf('On particle %i\n',i)    
        
        % Drop and Allign
        drop(particleArray,i);                            % Move particle towards floor while gathering touched particle indicies and aligning
        if ithParticle.touching == 0                      % f particle i is not touching anyone after drop than it is on the ground                              
            continue                                      % no need to contine if your on the ground
        end
        
        % Allign With Multiple Particles
        ithParticle.prevTouch = ithParticle.landing;                     % Denote landing particle as previously touching to allign with multiple particles
        while (isTouching(particleArray,i) > 0) && (terminate == false)  % If particle is touching multiple others after intial drop and allignment
            ithParticle.landing = isTouching(particleArray,i);           % Select an overlaping particle to land on, (counting backwards from nParticles)
            place(particleArray,i);                                      % Place ith paticle between the particle it's touching and the particle it will land on
            ithParticle.prevTouch = ithParticle.landing;                 % Save the particle you landed on 
        end

        % Rotate
        while (terminate == false) && (reversed(particleArray,i) == false)           % While particle doesn't reverse rotation or dummy particle doesn't collide
            notCollided = @(particleArray,i) isTouching(particleArray,i) == 0; %
            aboveGround = @(particleArray,i) ithParticle.z > ithParticle.r;

            while notCollided(particleArray,i) && aboveGround(particleArray,i) && (terminate == false) % While not touching other particles and within bounds
                rotate(particleArray,i);                                       % Rotate the ith Paticle around its touching particle
                ithParticle.landing = isTouching(particleArray,i);             % Declare landing partilce as the partice the ith particle rolls into
            end
            if (ithParticle.landing == 0) && (terminate == false)              % If you rotated and y went below 0, then place between floor and touching particle
                floorSet(particleArray,i);                                      % Set on floor
                viscircles(P(i).center,P(i).r,'EdgeColor','b');   % debug
                pause;
                break                                              % and terminate 
            end
            % Place Particle 
            if terminate == false;
                place(particleArray,i);                                % Place ith particle between touching and landing particles
            end
            ithParticle.prevTouch = ithParticle.landing;           % Denote landing particle as previously touching in case ith particle touches multiple particles
            while (isTouching(particleArray,i) > 0) && (terminate == false)   % If particle is overlapping others after placement place again
                ithParticle.landing = isTouching(particleArray,i);
                place(particleArray,i);
                ithParticle.prevTouch = ithParticle.landing;           % Denote landing particle as previously touching to allign with multiple particles
            end

            % Reset Properties
            ithParticle.prevTouch = ithParticle.touching;                   % Resest variables for next loop
            ithParticle.touching = ithParticle.landing;                     % Landing particle becomes touching particle
            ithParticle.landing = 0;
        end
        viscircles(P(i).center,P(i).r,'EdgeColor','b');   % debug
        pause;
    end
end                                                             
    

