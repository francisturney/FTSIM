function move(particleArray,i,x,z)
    import bedGeometry.*        % Package of functions controlling bed Geometry

    % Declare
    global nDummies;                    % Number of dummy particles created
    global terminate;                   % terminate the ith particle's placement
    P = particleArray;                  % Simplify notation
    dI = P(i).dummyIndex;               % Simplify notation
    bound1 = 30;                        % Lower bound
    bound2 = 130;                       % Upper bound
    
    
    % Move P(i)
    P(i).z = z;                         % Set z coordinate
    P(i).x = x;                         % Set x coordinate
    P(i).center=[x,z];                  % Set Center
    
    viscircles(P(i).center,P(i).r);   % debug
    pause;
    
    % Check for out of Bounds
    if ((x - P(i).r) < bound1)                  % If particle is moved past the lower bound                                 
        if P(i).dummyIndex == 0;                % If P(i) doesn't have a dummy particle already 
            nDummies = nDummies + 1;            % Account for a new dummy particle P(dI)
            P(i).dummyIndex = 50 + nDummies;    % In P(i)'s properties, note the index of the new particle 
            dI = P(i).dummyIndex;               % Simplify notation
            P(dI).dummyFriend = i;              % Note the particle that created the dummy particle     
        end
        
        % Set Dummy Particle
        P(dI).x = (bound2 + (P(i).x - bound1));
        P(dI).z = P(i).z;
        P(dI).r = P(i).r;
        P(dI).center = [P(dI).x, P(dI).z];

        viscircles(P(dI).center,P(dI).r);   % debug
        pause;
        
        % Uppon Dummy Collision
         if isTouching(P,dI) > 0;                 % If dummy particle is touching another particle
            P(dI).landing = isTouching(P,dI);     % Tell the dummy to land on it 
            nDummies = nDummies + 1;              % Account for a new dummy particle P(dI2) mirror of P(i).touching
            P(dI).dummyIndex = 50 + nDummies;     % In the dummy properties, note the index of the new particle 
            dI2 = P(dI).dummyIndex;               % Simplify Notation
            
            % Set P(dI2) opposite from P(i).touching 
                P(dI2).x = bound2 + (P(P(i).touching).x - bound1);
                P(dI2).z = P(P(i).touching).z;
                P(dI2).r = P(P(i).touching).r;
                P(dI2).center = [P(dI2).x, P(dI2).z];

                viscircles(P(dI2).center,P(dI2).r)  % debug
                pause;
            
            % Place P(dI) between P(dI2) and P(P(i).touching)
                P(dI).touching = dI2;
                placeDummy(particleArray, dI);
                         
                viscircles(P(dI).center,P(dI).r)  % debug
                pause;
            
            % Allign P(i) with now placed dummy particle
                P(i).x = bound1 + (P(dI).x - bound2);
                P(i).z = P(dI).z;
                P(i).center = [P(i).x, P(i).z];
         
                viscircles(P(i).center,P(i).r)  % debug
                pause;

            % Send terminate back to initialize bed so we can move on to
            % placing the next particle
                terminate = true;
                return
         end
    end
    
    % Check for out of bounds
    if ((x + P(i).r) > bound2)                                
        if P(i).dummyIndex == 0;                % If P(i) doesn't have a dummy particle assosiated with it
            nDummies = nDummies + 1;            % Account for a new dummy particle P(dI) mirror of P(i).touching
            P(i).dummyIndex = 50 + nDummies;    % In the properties of P(i), note the index of the new particle 
            dI = P(i).dummyIndex;               % Simplify notation
            P(dI).dummyFriend = i;              % Note the particle that created the dummy particle     
        end
        
        % Set Dummy Particle
        P(dI).x = (bound1 - (bound2 - P(i).x));
        P(dI).z = P(i).z;
        P(dI).r = P(i).r;
        P(dI).center = [P(dI).x, P(dI).z];
        
        viscircles(P(dI).center,P(dI).r)
        pause;
     
    % Uppon Dummy Collision
         if isTouching(P,dI) > 0;                 % If dummy particle is touching another particle
            P(dI).landing = isTouching(P,dI);     % Tell the dummy to land on it 
            nDummies = nDummies + 1;              % Account for a new dummy particle P(dI2) mirror of P(i).touching
            P(dI).dummyIndex = 50 + nDummies;     % Note the index of the new particle 
            dI2 = P(dI).dummyIndex;               % Dummy of dummy particle (double dummy)
            
            % Set double dummy in bed
                P(dI2).x = bound1 - (bound2 - P(P(i).touching).x);
                P(dI2).z = P(P(i).touching).z;
                P(dI2).r = P(P(i).touching).r;
                P(dI2).center = [P(dI2).x, P(dI2).z];
                
                viscircles(P(dI2).center,P(dI2).r)   % debug
                pause;
 
            % Place dummy between double dummy and P(i).touching
                P(dI).touching = dI2;
                placeDummy(particleArray, dI);
                
                viscircles(P(dI).center,P(dI).r)   % debug
                pause;
            
            % Allign P(i) with dummy particle
                P(i).x = bound2 - (bound1 - P(dI).x);
                P(i).z = P(dI).z;
                P(i).center = [P(i).x, P(i).z];

                viscircles(P(i).center,P(i).r)  % debug
                pause;
            
            % Send terminate back to initialize bed so we can move on to
            % placing the next particle
                terminate = true;
                return
        end
    end
            
end