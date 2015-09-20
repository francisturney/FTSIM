% Script: Main
% Description:  Creates a 2D bed of circular particles, calulates drag and gravity forces for the
% particles most suseptable to entrainment, and computes the fluid threshold for thoses particle.
% Statistics are gathered and presented at the end as well as a graphicall illustration of the bed.
clear
%profile on

% PACKAGES AND CLASSES
import bedGeometry.*        % Package of functions controlling bed Geometry
import dataAnalysis.*       % Package of functions for data analysis and calculation
import particle             % Class modeling individual sand particles as circles
tic
    
% INPUT
    modelRuns = 7;               % Number of input sets to generate data on, if number is greater than one skip to the if statement below
    MultiThread = false;         % Use of Multi-core/Multi-thread processor
    nParticles = 100;            % Number of particles per bed formation
    range = 100;                 % Range of placement
    mRepetitions = 300;          % Number of model runs, i.e. number of times a bed is created and data colected on it, 300 represents 1000 CFM (100 particles)
    meanParticleDiameter = 0.4;  % Average Radius of Particle (mm)
    stdDeviation = 0.2;          % Deviation of the radius from its mean (lognormally distributed) (mm)
    Cd = 1;                      % Drag Coeficient
    rhoSand = 2650;              % Density of quarts sand (kg/m^3) taken from midpoint of top and bottom values on engineeringtoolbox.com                          
    rhoAir = 1.2041;             % Density of air (kg/m^3) sea level from wikipedia 
    k = 0.41;                    % Von Karmen constant 
    mu = 1.846;                  % Dynamic viscosity of air at 300 K (engineering toolbox)
    g = 9.80665;                 % Acceleration due to gravity (m/s^2) by convention 
    z0 = 4/30;                   % Roughness Length D/30
    Beta = 10^(-4);                % Coeficient for interparticle cohesion, 10^-4 from Shao and Lu, 2000, 0.0012 from Corn 1961 
    run = 1;
    
    if modelRuns > 1
       nParticles = (50:25:200);
        
    end
    
    
 % PARALELL POOL
    if MultiThread == true;
         parpool;
         pool = gcp;
         addAttachedFiles(pool, {'bedGeometry', 'particle.m', 'dataAnalysis'});
    end  
    
    

% DECLARE
    % Statistics stucture
    stats(modelRuns) = struct('L', 0, 'H', 0, 'meanDp', 0 ,'stdDevDp', 0,...
                   'uft10', [], 'uft30', 0, 'uft50', [], 'uft60', [], ...
                   'heights', 0, 'nCFMs', 0, 'uft', 0, 'DpCFM', 0,  ...
                   'Dp10CFM', 0, 'Dp30CFM', 0, 'Dp50CFM', 0, 'Dp60CFM', 0);
               
% EXPERIMENT LOOP
for run=1:modelRuns
    % DECLARE
        % Array of Particles
        particleArray(mRepetitions,3*nParticles(run)) = particle;
        stdDevPercent = meanParticleDiameter/(2*stdDeviation);    % Standard deviation as a percentage of mean, for constructor of particle class
        for i=1:mRepetitions                                % Create particles
            for j=1:(3*nParticles(run)) 
                particleArray(i,j) = particle(range, stdDevPercent);
            end
        end

        % Array of Particle Structs
        P(mRepetitions,3*nParticles(run)) =  struct('x',0,'z',0,'r',0,'center',[],'top',false,'CFM',false,'mD',0,'mG',0,'uft',0,...
           'pivPoint',[],'liftPoint',0,'wake', 0, 'expArea',0,'destroyed',0,'ave',0, 'I', 0, 'lift', 0, 'pivot', 0);



    % SIMULATION LOOP
    parfor i=1:mRepetitions 
         import bedGeometry.*        % Referance to path for workers
         import dataAnalysis.*       % Referance to path for workers
         import particle             % Referance to class for workers
         pool = gcp;
         addAttachedFiles(pool, {'bedGeometry', 'particle.m', 'dataAnalysis'});


        fprintf('On model run number %f\n',i);
        %try      
             % Place Particles in Bed
             particleArray(i,:) = initializeBed(particleArray(i,:),nParticles(run), range);             

             % Identify Top Row of Particles
             particleArray(i,:) = idTop(particleArray(i,:),nParticles(run),range);                 

             % Calculate Average Height of Top Row
             particleArray(i,:) = averageHeight(particleArray(i,:),nParticles(run));                             

             % Identify Canidates For Movement
             particleArray(i,:) = idCFM(particleArray(i,:), nParticles(run));

             % Assign Lift Point (for area exposed to flow)
             particleArray(i,:) = assnLift(particleArray(i,:),nParticles(run));  

             % Assign Pivot Point and Moment Arms           
             particleArray(i,:) = assnPivot(particleArray(i,:),nParticles(run));

             % Calculate Fluid Threshold Shear Velocity For Each Particle
             particleArray(i,:) = solveUft(particleArray(i,:),nParticles(run), meanParticleDiameter, Cd,k,mu,rhoAir,rhoSand,g,z0,Beta); 

             % Normalize Moment Arms
             particleArray(i,:) = NormalizeMomentArms(particleArray(i,:),nParticles(run));  

             % Move Data into Structure Array to easily view properties
             P(i,:) = gatherData(P(i,:),particleArray(i,:),nParticles(run));       

             % Print Particle Bed
    %         Print(particleArray(i,:), nParticles(run), range);           

    %     catch
    %         disp('Error')
    %         continue
    %     end
    end
    % Test stuct Array and display
    P1 = P(1,:);
    % MODEL STOP
    
    % DATA ANALYSIS
    stats(run) = dataAnalysis(stats(run), P, nParticles(run), mRepetitions, range, meanParticleDiameter, stdDeviation);

end
save('sensitivityTest_range100_nparticle50_200',stats)
%profile viewer
toc
elapsedTime = toc/60;                                           %give run time in seconds and minutes
fprintf('or %d minutes\n',elapsedTime)