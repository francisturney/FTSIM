% Function: averageHeight
% Description: Finds the average height of the top row of particles

function particleArray = averageHeight(particleArray,nParticles)
    import bedGeometry.*        % Package of functions controlling bed Geometry
    import particle
    nDummies = 2*nParticles;
    
    averageHeight = 0;
    n = 0;
    for i=1:nParticles + nDummies
        if particleArray(i).isTop
            n = n+1;
            averageHeight = averageHeight + particleArray(i).z;
        end
    end
    averageHeight = averageHeight/n;
    for i=1:nParticles + nDummies
        %if particleArray(i).isTop
            particleArray(i).ave = averageHeight;
        %end
    end
end