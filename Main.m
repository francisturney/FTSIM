% Script: Main
% Description:  Creates a 2D bed of circular particles, calulates drag and gravity forces for the
% particles most suseptable to entrainment, and computes the fluid threshold for thoses particle.
% Statistics are gathered and presented at the end as well as a graphicall illustration of the bed.
clear
%parpool
%parpool('local',4)
%parpool

% PACKAGES AND CLASSES
import bedGeometry.*        % Package of functions controlling bed Geometry
import dataAnalysis.*       % Package of functions for data analysis and calculation
import particle             % Class modeling individual sand particles as circles
tic

% USER INPUTS
    nParticles = 100;            % Number of particles per bed formation
    lBound = 100;                % Lower bound
    range = 100;                 % Range of placement
    mRepetitions = 1;            % Number of model runs, i.e. number of times a bed is created and data colected on it, 300 represents 1000 CFM (100 particles)
    meanParticleRadius = 0.05;   % Average Radius of Particle (mm)
    stdDeviation = 0.01;         % Deviation of the radius from its mean (lognormally distributed)
    Cd = 1;                      % Drag Coeficient
    rhoSand = 2650;              % Density of quarts sand (kg/m^3) taken from midpoint of top and bottom values on engineeringtoolbox.com                          
    rhoAir = 1.2041;             % Density of air (kg/m^3) sea level from wikipedia 
    k = 0.41;                    % Von Karmen constant 
    mu = 1.846;                  % Dynamic viscosity of air at 300 K (engineering toolbox)
    g = 9.80665;                 % Acceleration due to gravity (m/s^2) by convention 
    z0 = 4/30;                   % Roughness Length D/30
    windProfile = 2;             % Switch for wind profile, 1 is logrithmic, 2 is linear, 3 is linear with wakes
    Beta = 10^(-4);                % Coeficient for interparticle cohesion, 10^-4 from Shao and Lu, 2000, 0.0012 from Corn 1961

    % DECLARE
    % Particle Array
    particleArray(mRepetitions,3*nParticles) = particle;
    for i=1:mRepetitions                     % Create particles
        for j=1:(3*nParticles) 
            particleArray(i,j) = particle(lBound,range);
        end
    end
    
    % Particle struct
    P(mRepetitions,3*nParticles) =  struct('x',0,'z',0,'r',0,'center',[],'top',false,'CFM',false,'mD',0,'mG',0,'uft',0,...
       'pivPoint',[],'liftPoint',0,'wake', 0, 'expArea',0,'destroyed',0,'ave',0, 'I', 0, 'lift', 0, 'pivot', 0);

% PARALLEL MODEL RUNS
for i=1:(mRepetitions) 
    import bedGeometry.*        % Referance to path for workers
    import dataAnalysis.*       % Referance to path for workers
    import particle             % Referance to class for workers
    
    fprintf('On model run number %f\n',i);
    %try      
         % Place Particles in Bed
         particleArray(i,:) = initializeBed(particleArray(i,:),nParticles, lBound, range);             
        
         % Identify Top Row of Particles
         particleArray(i,:) = idTop(particleArray(i,:),nParticles,lBound,range);                 
  
         % Calculate Average Height of Top Row
         averageHeight(particleArray(i,:),nParticles);                             
 
         % Identify Canidates For Movement
         particleArray(i,:) = idCFM(particleArray(i,:), nParticles);
         
         % Assign Lift Point (for area exposed to flow)
         particleArray(i,:) = assnLift(particleArray(i,:),nParticles);  
         
         % Assign Pivot Point and Moment Arms           
         particleArray(i,:) = assnPivot(particleArray(i,:),nParticles);
         
         % Calculate Fluid Threshold Shear Velocity For Each Particle
         particleArray(i,:) = solveUft(particleArray(i,:),nParticles, Cd,k,mu,rhoAir,rhoSand,g,z0,Beta); 
         
         % Normalize Moment Arms
         particleArray(i,:) = NormalizeMomentArms(particleArray(i,:),nParticles);  
 
         % Move Data into Structure Array to easily view properties
         P(i,:) = gatherData(P(i,:),particleArray(i,:),nParticles);       
        
         % Print Particle Bed
         Print(particleArray(i,:), nParticles, range, lBound);           

%     catch
%         disp('Error')
%         continue
%     end
end

% Test stuct Array
P1 = P(1,:);
toc
elapsedTime = toc/60;                                           %give run time in seconds and minutes
fprintf('or %d minutes\n',elapsedTime)
%MODEL STOP
