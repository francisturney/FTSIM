% Function : initializeBed
% Description : Initializes particle bed, first by droping, then rotating each particle around subsequent
% collied particles to find the final position upon rotation reversal.
% Input : Particle Array and the kth repetition your on 
function P = initializeBed(P,nParticles, lBound, range)
    % Setup
    import bedGeometry.*                              % Package of functions controlling bed Geometry    
    import particle
    nDummies = 0;                                % Number of dummy particles for making periodic boundary conditions
    terminate = 0;                               % Terminates placement of particle
    nDummies = 0;                                % Start off with no dummies
    %P = particleArray(ithRep,:)                         % Simplify notation
    for i=1:nParticles
        if mod(i,10) == 0;
            fprintf('On particle %i\n',i);
        end
        % PERIODIC BOUNDARY CONDITIONS
            if i > 1          
                % Right Dummy
                nDummies = nDummies + 1;                            % Keep Track of Dummies created,
                P(nParticles + nDummies).r = P(i-1).r;              % that are mirrors of the previous run's particle,
                P(nParticles + nDummies).x = P(i-1).x + range;      % but 100 above it in x
                P(nParticles + nDummies).z = P(i-1).z;
                P(nParticles + nDummies).center = [P(nParticles + nDummies).x, P(nParticles + nDummies).z];

                % Left Dummy 
                nDummies = nDummies + 1;                              % Create dummies,
                P(nParticles + nDummies).r = P(i-1).r;                % that are mirrors of the previous run's particle,
                P(nParticles + nDummies).x = P(i-1).x - range;        % but are 100 below it in x
                P(nParticles + nDummies).z = P(i-1).z;
                P(nParticles + nDummies).center = [P(nParticles + nDummies).x, P(nParticles + nDummies).z];
             end 
        % DROP
            inLine = 0;                             % Particles in the way of P(i)
            k = 0;                                  % Number of particle in the way of P(i)
            for j=(i-1):-1:1
                iRight = P(i).x + P(i).r;           % Boundaries of P(i)'s and P(j)'s projection on the x-axis
                iLeft = P(i).x - P(i).r;
                jRight = P(j).x + P(j).r;
                jLeft = P(j).x - P(j).r;
                if (iLeft < jRight) && (jLeft < iRight)     % If the two lines are not overlapping
                    inLine(j) = P(j).z + P(j).r;            % inLine records the highest particle in line and it's index in P                       
                end
            end
            if inLine == 0;                       % If nothing in the way to the bottom
                P(i).z = P(i).r;                  % Set P(i) on ground
                P(i).center = [P(i).x, P(i).z];
                continue
            end
            [M,iTouch] = max(inLine);
            P(i).touching = iTouch;
            % Place From Drop
            P(i).z = P(iTouch).z + sqrt((P(i).r + P(iTouch).r)^2 - (P(i).x - P(iTouch).x)^2);
            P(i).center = [P(i).x, P(i).z];
            
        % SETTELING ALGORITH
        k = 0;
        l = 0;
        t = 0;
        oldTouch = 0;
        while notWedged(P,i)
            terminate = false;
            k = k + 1;
            if k > 1
                 P(i).touching = P(i).landing;
                 P(i).landing = 0;
            end
            Dist = [];
            Min = 0;
            P(i).LR = whichSide(P,i);
            if P(i).LR == -1;
                for j=(nParticles + nDummies):-1:1
                    if (j >= i) && (j <= nParticles)
                         Dist(j) = 2000;
                         continue
                    end
                    if P(j).x < P(P(i).touching).x 
                        Dist(j) = pdist([P(i).center; P(j).center],'euclidean');
                    else
                        Dist(j) = 2000;
                    end
                    [Min,iLand] = min(Dist);
                    P(i).landing = iLand;
                end
            else if P(i).LR == 1;
                    for j=(nParticles + nDummies):-1:1
                        if (j >= i) && (j <= nParticles)
                            Dist(j) = 2000;
                            continue
                        end
                        if P(j).x > P(P(i).touching).x 
                            Dist(j) = pdist([P(i).center; P(j).center],'euclidean');
                        else
                            Dist(j) = 2000;
                        end
                        [Min,iLand] = min(Dist);
                        P(i).landing = iLand;
                    end    
                end
            end
            if Min == 2000;
                    floorSet(P,i);
                    % viscircles(P(i).center,P(i).r, 'EdgeColor', 'b')   % debug
                    % pause;
                    terminate = true;
                    break
            end
            while ~place(P,i) 
                Dist(iLand) = 2000; % Distance to iLand is much farther     
                [Min,iLand] = min(Dist);
                P(i).landing = iLand;
                if Min == 2000;
                    floorSet(P,i);
                    % viscircles(P(i).center,P(i).r, 'EdgeColor', 'b')   % debug
                    % pause;
                    terminate = true;
                    break
                end
            end
            if terminate == true; break; end
            % viscircles(P(i).center,P(i).r);   % debug
            % pause;
            % number of times in is touching, for high numbers, infanite loop, scratch the particle
            while isTouching(P,i,nParticles,nDummies) > 0
                P(i).prevTouch = P(i).landing;
                P(i).landing = isTouching(P,i,nParticles,nDummies);
                P(i).touching = P(i).prevTouch;
                place(P,i);
                % viscircles(P(i).center,P(i).r);   % debug
%                 fprintf('P(i).touching = %f P(iTouch).x = %f\n',P(i).touching,P(P(i).touching).x)
%                 fprintf('P(i).landing = %f P(iLand).x = %f\n',P(i).landing,P(P(i).landing).x)
%                 fprintf('isTouching(P,i) = ')
%                 isTouching(P,i)
                if P(i).touching == oldTouch; l = (l + 1) ; end
                t = (t + 1);                                        % instability counter
                if t > 100; destroy(P(i)); terminate = true; break; end
                if l > 5; k = 0; end
                oldTouch = P(i).touching;
                % pause;
            end
            % viscircles(P(i).center,P(i).r, 'EdgeColor', 'r');   % debug
            % pause;
            if terminate == true; break; end;
        end  
    end
    % Periodic Boundary Conditions 
            nDummies = nDummies + 1;                            % Create dummies,
            P(nParticles + nDummies).r = P(i).r;              % that are mirrors of the previous run's particle,
            P(nParticles + nDummies).x = P(i).x + range;        % but 100 above it in x
            P(nParticles + nDummies).z = P(i).z;
            P(nParticles + nDummies).center = [P(nParticles + nDummies).x, P(nParticles + nDummies).z];
            
            nDummies = nDummies + 1;                            % Create dummies,
            P(nParticles + nDummies).r = P(i).r;              % that are mirrors of the previous run's particle,
            P(nParticles + nDummies).x = P(i).x - range;        % but are 100 below it in x
            P(nParticles + nDummies).z = P(i).z;
            P(nParticles + nDummies).center = [P(nParticles + nDummies).x, P(nParticles + nDummies).z];
    
end