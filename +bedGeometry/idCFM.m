% Function: idCFM (Canidates For Movement)
% Description: If the jth particle is above the particles it touches than it is a canidate for movement

function P = idCFM(particleArray,nParticles)  
    import bedGeometry.*        % Package of functions controlling bed Geometry
    P = particleArray;          % Simplify notation
    l = 0;
    aveCFM = 0;
    nDummies = 2*nParticles;
    ave = P(1).ave;
    
    for i=1:nParticles + nDummies                                               %reset top
        if P(i).isTop == true;
            P(i).isCFM = true;
            k=0;                              % Counter for touching above positioned particles
            for j=1:nParticles + nDummies
                if i == j
                    continue
                end
                if (pdist([P(i).center; P(j).center],'euclidean') <= (P(i).r + P(j).r + .5)) && (P(i).z < P(j).z) %If the P(i) touches and is below P(j) then P(i) is not on top
                     P(i).isCFM = false;
                end
                if P(i).z <= (P(i).r + 1)
                   P(i).isCFM = false;
                end
                if P(i).z <= ave
                   P(i).isCFM = false;
                end
            end
            if P(i).isCFM == true
                aveCFM = aveCFM + P(i).z + P(i).r;
                l = l + 1;
            end     
        end
    end
    aveCFM = aveCFM/l;
    for i=1:nParticles + nDummies
        P(i).aveCFM = aveCFM;
    end
end
    
