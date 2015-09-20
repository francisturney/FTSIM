% Function : initializeBed
% Description : Initializes particle bed, first by droping, then rotating each particle around subsequent
% collied particles to find the final position upon rotation reversal.
% Input : Particle Array and the kth repetition your on 
function P = initializeBed(P,nParticles, range)
    % Setup
    import bedGeometry.*                              % Package of functions controlling bed Geometry    
    import particle
    nDummies = 0;                                % Number of dummy particles for making periodic boundary conditions
    terminate = 0;                               % Terminates placement of particle
    nDummies = 0;                                % Start off with no dummies
%s
    for i=1:nParticles                           % For all particles
%         if mod(i,10) == 0;
%             fprintf('On particle %i\n',i);
%         end
        
        % PERIODIC BOUNDARY CONDITIONS
            if i > 1                                                % Acts recursivly on P(i-1) so that dummy particles are only created
                                                                    % once the particle has been placed
                % Right Dummy
                nDummies = nDummies + 1;                            % Keep Track of Dummies created,
                P(nParticles + nDummies).r = P(i-1).r;              % Dummies are mirror particles of the previous run's particle,
                P(nParticles + nDummies).x = P(i-1).x + range;      % but 100 above it in x
                P(nParticles + nDummies).z = P(i-1).z;
                P(nParticles + nDummies).center = [P(nParticles + nDummies).x, P(nParticles + nDummies).z]; % Update center

                % Left Dummy 
                nDummies = nDummies + 1;                            % Create dummies,
                P(nParticles + nDummies).r = P(i-1).r;              % Dummies are mirror particles of the previous run's particle,
                P(nParticles + nDummies).x = P(i-1).x - range;      % but are 100 below it in x
                P(nParticles + nDummies).z = P(i-1).z;
                P(nParticles + nDummies).center = [P(nParticles + nDummies).x, P(nParticles + nDummies).z]; % Update center
            end 
             
        % DROP
            inLine = 0;                                             % Particles in the path of P(i)
            k = 0;                                                  % Number of particle in the way of P(i)      
            % Check for particles in the path of P(i)
                for j=(i-1):-1:1
                    % i or j Right and Left are endpoints of the howizontal radius of P(i) or P(j), if P(i)'s and P(j)'s horizontal radii
                    % overlap then P(j) is in the path of P(i), since P(i) is falling vertically
                    iRight = P(i).x + P(i).r; iLeft = P(i).x - P(i).r;
                    jRight = P(j).x + P(j).r; jLeft = P(j).x - P(j).r;
                    if (iLeft < jRight) && (jLeft < iRight)             % If the two lines are overlapping
                        inLine(j) = P(j).z + P(j).r;                    % inLine records the highest particle in line and it's index in P                       
                    end
                end
                if inLine == 0;                                         % If nothing in the way to the bottom
                    P(i).z = P(i).r;                                    % Set P(i) on ground
                    P(i).center = [P(i).x, P(i).z];                     % Update center
                    continue
                end
                [M,iTouch] = max(inLine);                               % find the highest particle in the path
                P(i).touching = iTouch;                                 % Set P(i) to touch the max particle
            % Place From Drop
            P(i).z = P(iTouch).z + sqrt((P(i).r + P(iTouch).r)^2 - (P(i).x - P(iTouch).x)^2); % Pathagorean theourm on touching triangle, we know everything except the z cordainate of P(i)
            P(i).center = [P(i).x, P(i).z];                             % Update center
            
        % SETTELING ALGORITHM
            % Declare
            k = 0;                                          % Counts the number of iterations in placement
            l = 0;
            t = 0;
            oldTouch = 0;
            
            % Placement Loop 
            while notWedged(P,i)                            % While not stuck between two particles
                terminate = false;                          % Terminate breaks from while loop later
                k = k + 1;
                
                % Switch touching and Landing Particles
                    if k > 1                                    
                         P(i).touching = P(i).landing;          % Switch touching so it becomes the particle P(i) previously lnaded on
                         P(i).landing = 0;                      % Reset Landing
                    end
                    Dist = [];
                    Min = 0;
                
                % Find Closest Particle
                P(i).LR = whichSide(P,i);                   % Determine which side of P(touching) P(i) is,
                if P(i).LR == -1;                           % if P(i) is on the left find the distances from P(i) to all others placed on the left of P(touching)
                    for j=(nParticles + nDummies):-1:1          % Include dummies
                        if (j >= i) && (j <= nParticles)        % Exclude particles not placed
                             Dist(j) = 2000;                    % by making them very far away
                             continue
                        end
                        if P(j).x < P(P(i).touching).x 
                            Dist(j) = pdist([P(i).center; P(j).center],'euclidean');
                        else
                            Dist(j) = 2000;
                        end
                        [Min,iLand] = min(Dist);                % Take the minimum distance
                        P(i).landing = iLand;                   % As the particle to land on
                    end
                else if P(i).LR == 1;                           % If P(i) is on the right of P(touching) find the distances from P(i) to all others placed on the right of P(touching)
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
                
                % Floor Set
                if Min == 2000;                             % If no particles at all
                        floorSet(P,i);
                        terminate = true;
                        break
                end
                while ~place(P,i)                       % If placement is impossible
                    Dist(iLand) = 2000;                 % Distance to iLand is much farther than anything else     
                    [Min,iLand] = min(Dist);
                    P(i).landing = iLand;
                    if Min == 2000;
                        floorSet(P,i);
                        terminate = true;
                        break
                    end
                end
                if terminate == true; break; end
                % viscircles(P(i).center,P(i).r);   % debug
                % pause;
                % number of times in is touching, for high numbers, infanite loop, scratch the particle
                
                % Main Setteling Algorithm
                while isTouching(P,i,nParticles,nDummies) > 0  % While P(i) is touching another particle excluding P(i).touching , P(i).landing and P(i).prevtouch
                    P(i).prevTouch = P(i).landing;
                    P(i).landing = isTouching(P,i,nParticles,nDummies);
                    P(i).touching = P(i).prevTouch;
                    if ~place(P,i)
                        destroy(P(i)); 
                        terminate = true;
                        break;
                    end
%                     viscircles(P(i).center,P(i).r);   % debug
%                     fprintf('P(i).touching = %f P(iTouch).x = %f\n',P(i).touching,P(P(i).touching).x)
%                     fprintf('P(i).landing = %f P(iLand).x = %f\n',P(i).landing,P(P(i).landing).x)
%                     fprintf('isTouching(P,i) = ')
                    %isTouching(P,i)
                    if P(i).touching == oldTouch; l = (l + 1) ; end
                    t = (t + 1);                                         % instability counter
%                     if t > 10;
%                         t
%                     end
                    if t > 30, destroy(P(i)); 
                        terminate = true;
                        break;
                    end  % If stuck in an infanite loop then destroy particle happens to 1 particle out of 100 at most. 
                    if l > 5, k = 0; end
                    oldTouch = P(i).touching;
                    % pause;
                end  
                
                % Attempt to elliminat 
%                 switch P(i).LR 
%                     case 1, 
%                         if (P(i).x > P(P(i).landing).x) && (P(i).z < P(P(i).landing).z)
%                             k = 0; 
%                         end
%                     case -1, 
%                         if P(i).x < P(P(i).landing).x && (P(i).z < P(P(i).landing).z)
%                             k = 0;
%                         end
%                 end
%                            
%                 disp('out of while')
%                 viscircles(P(i).center,P(i).r, 'EdgeColor', 'r');   % debug
%                 pause;
                if terminate == true; break; end;
            end  
    end
    % Periodic Boundary Conditions for last particle only 
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