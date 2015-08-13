% Function: averageHeight
% Description: Finds the average height of the top row of particles

function averageHeight = averageHeight(particleArray)
    global nParticles
    global nDummies
    import bedGeometry.*        % Package of functions controlling bed Geometry
    
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
        if particleArray(i).isTop
            particleArray(i).ave = averageHeight;
        end
    end
end