function [] = rotate(particleArray, j)      % Rotate jth particle around the particle it's touching
        import bedGeometry.*                % Package of functions controlling bed Geometry
            
        P = particleArray;                          % Simplify notation
        touching = particleArray(j).touching;       % ...
        LR = particleArray(j).LR ;                  % ...
        
        theta = asin((P(j).z - P(touching).z)/pdist([P(j).center; P(touching).center],'euclidean'));    
        r2 = P(j).r + P(touching).r;
        z = P(touching).z + r2*sin(theta - (1/9)*pi);             %(1/9)pi is angle of rotation
        x = P(touching).x + LR*r2*cos(theta - (1/9)*pi);
        move(particleArray,j,x,z);
end

        
            
        
        
        