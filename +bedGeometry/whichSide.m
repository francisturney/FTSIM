% Function : whichSide
% Description : Determines which side of it's touhcing particle the jth Particle is on (left/right) (LR=-1,LR=1)

function LR = whichSide(particleArray,j)         
    % Changed touching to landing
    % Declare 
    import bedGeometry.*                                   % Package of functions controlling bed Geometry
    jthParticle = particleArray(j);                        % Simplify notation
    jTouched = particleArray(particleArray(j).touching);   % Particle that jth particle is touching
    
    LR = -1;                                               % Derermine which side of the touching particle the jth particle is on 
    if (jthParticle.x > jTouched.x) 
        LR = 1;
    else
        LR = -1;
    end
end 