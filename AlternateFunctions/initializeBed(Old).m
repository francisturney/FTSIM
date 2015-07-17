function P = initializeBed(P,N)                             %INITIALIZE BED
import bedGeometry.*        % Package of functions controlling bed Geometry

%**************************************************************************
%   Makes an array of structure arrays which represents a collection of 
%circular particles, then places them as if they'd fallen onto the floor 
%from gravity. You can set the particle radii as well as their number and 
%range. The alogrithm for placement simulates falling as the particles
%are dropped in the vertictal direction untill collision with floor or
%other particle and then rotated around particles untill further collision
%and eventual resting based on reversal of rotation after collision. 
%**************************************************************************                                            
    %CREATE PARTICLES AND INITIALIZE PARTICLE BED
    for i=1:N   
        fprintf('On particle %i\n',i)                               %print progress 
        %DECALRE PARTICLE GEOMETRY
        P(i).r = 4 + 1.*randn(1,1);                                  %Particle radius  
        P(i).x = 20 + (120).*rand(1);                               %x coordinate of center                                         
        P(i).y = 70;                                                %y coordinate of center
        P(i).center = [P(i).x,P(i).y];                              %set 'center' feild
        %DECLARE PARTICLE INDICIES
        init=0;                                                     %particle i has landed on
        final=0;                                                    %particle i will land on
        prevInit = 0;                                               %init from previous loop  
        %DECLARE OTHER
        c = 0;                                                      %particle oriantation coeficint: (-1) for left (1) for right

        %DROP P(I) TO FIND P(MAX) AND C
        [P,i,init,c] = drop(P,i,init,c);                            %if particle reaches floor init is 0 
        if init == 0
            continue                                                %no need to rotate if your on the ground
        end
        while (touching(P,i,init,final) ~= 0)                       %If particle is overlapping others after placement
            final = touching(P,i,init,final);
            P = place(P,i,final,init);
            prevInit = final;                                       %to align before rotatiing 
        end

        %FIND THE FINAL POSITION OF P(I) THROUGH ROATATE LOOP AND COLLISION TERMNIATE
        while (reversed(P,i,init,c) == false)                       %TERMINATE IF PARTICLE REVERSES ROTATION UPON COLLISION AND PLACEMENT
            while ((touching(P,i,init,prevInit) == 0)) && (P(i).y > P(i).r) %while not touching other particles and within bounds
                P=rotate(P,i,init,c);                               %rotate
                final = touching(P,i,init,prevInit);                %Assign min to the particle P(i) is touching (0 if not touching)
            end
            if final == 0                                           %If there is no closest
                P = floorSet(P,i,init,c);                           %Set on floor
                break                                               %and terminate 
            end
            %PLACE PARTICLE 
            P = place(P,i,final,init);                              %Calculate and assign new position
            while (touching(P,i,init,final) ~= 0)                   %If particle is overlapping others after plac
                final = touching(P,i,init,final);
                P = place(P,i,final,init);
            end
            prevInit = init;                                        %Resest variables for next run
            init = final;
            final = 0;
        end
    end                                                             %END OF INITIALIZE
    fprintf('bed intialized\n')
end
