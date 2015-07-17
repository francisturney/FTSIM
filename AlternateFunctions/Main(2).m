%MAIN
import bedGeometry.*        % Package of functions controlling bed Geometry
import dataAnalysis.*       % Package of functions for data analysis and calculation
tic

%**************************************************************************
%   Simulates the initiation of saltation in an Aolean setting, and
%calculates the fluid threshold shear velocity (uft) for each particle.
%                           STEP LIST  
%   Declare particle structure
%   Creates a random bed of particles
%   Identifies the top layer
%   Calculates the average height of the surface
%   Assigns pivot points
%   Calculates moment arms for Drag and Gravity forces
%   Calculates exposed area based on "anti-pivot points" 
%   Solves for uft through moment balance eqn
%**************************************************************************

% Set Number of particle per iteration (nParticles)
    nParticles = 50; % Number of particles per bed formation
    
% Set number of iterations (mIterations) of bed creation and subsequent
% data collecttion
    % Total number of particles created is mIterations times nParticles (nParticles = #particles in bed)
    % Total number of top particles (i.e. canidates for movement) will vary
    mIterations = 1;
    

for i=1:(mIterations)
    fprintf('On iteration number %f\n',i);
    %try

    %DECLARE PARTICLE AS OBJECT IN STRUCTURE ARRAY
    P = 0;      %P is an array of structure arrays, each particle being a struct array P(i) and P being the array of P(1) - P(N) struct arrays
    P = struct('x',0,'y',0,'r',0,'center',[],'top',false,'mD',0,'mG',0,'uft',0,...
        'pivPoint',[],'antiPivPoint',0,'piv',0,'antiPiv',0,'expArea',0);
    nParticles = 50; %NUMBER OF PARTICLES PER BED                                                                  %number of particles

    %INITIALIZE BED
    P = initializeBed(P,nParticles);

    %INDENTIFY TOP ROW OF PARTICLES
    P=idTopOld(P,nParticles);

    %CALCULATE AVERAGE HEIGHT
    ave = averageHeight(P,nParticles);

    %ASSIGN PIVOT PARTICLES 
    P = assnPivot(P,nParticles);

    %CALCULATE MOMENT ARMS AND ASSIGN PIVOT POINTS
    P = momentArms(P,nParticles);

    %ASSIGN ANTI-PIVOT PARTICLES & CREATE ANTI-PIVOT POINT                   
    P = assnAntiPivot(P,nParticles);

    % Identify top particles that are canidates for movement
    P = idTop(P,nParticles);

    %SOLVE FOR uft FLUID THRESHOLD SHEAR VELOICTY*
    P = solveUft(P,nParticles,ave);

    %NORMALIZE MOMENT ARMS
    P = NormalizeMomentArms(P,nParticles);

%FINISH ITERATION AND ASSIMILATE P INTO PTOT (which contains all the particles created)    
        if i==1
            Ptot = P;
        else
            Ptot = [Ptot,P];
        end
    %catch
       % continue
    %end
end
toc
elapsedTime = toc/60;                                           %give run time in seconds and minutes
fprintf('or %d minutes\n',elapsedTime)
%MODEL STOP
