% Function: idCFM (Canidates For Movement)

function idCFM(particleArray,nParticles)                         
    import bedGeometry.*        % Package of functions controlling bed Geometry  
    P = particleArray;      % Simplify notation

    for i=1:nParticles                                               %reset top
        if P(i).isCFM == true;    
            k=0;                              % Counter for touching above positioned particles
            for j=1:nParticles
                if i == j
                    continue
                end
                if (pdist([P(i).center; P(j).center],'euclidean') <= (P(i).r + P(j).r + 1)) && (P(i).y < P(j).y) %If the P(i) touches and is below P(j) then P(i) is not on top
                        P(i).top = false;
                end
                if P(i).y <= (P(i).r + 1)
                   P(i).top = false;
                end
                if (P(i).x < 10) || (P(i).x > 170)              %If P(i) is too close to the edge of range then it is not on top
                    P(i).top = false;
                end
            end
        end
    end
end
    
