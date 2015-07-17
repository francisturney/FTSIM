% Script: Main
% Description:  Creates a 2D bed of circular particles, calulates drag and gravity forces for the
% particles most suseptable to entrainment, and computes the fluid threshold for thoses particle.
% Statistics are gathered and presented at the end as well as a graphicall illustration of the bed.
clear

% Set Up
import bedGeometry.*        % Package of functions controlling bed Geometry
import dataAnalysis.*       % Package of functions for data analysis and calculation
import particle             % Class modeling individual sand particles as circles
tic
global nParticles           % Number of particles per bed
global nDummies

% User Inputs
    nParticles = 150;            % Number of particles per bed formation
    mRepetitions = 1;           % Number of model runs, i.e. number of times a bed is created and data colected on it
    meanParticleRadius = 0.05;  % Average Radius of Particle (mm)
    stdDeviation = 0.01;        % Deviation of the radius from its mean (lognormally distributed)
    Cd = 1;                     % Drag Coeficient
    rhoSand = 2650;             % Density of quarts sand (kg/m^3) taken from midpoint of top and bottom values on engineeringtoolbox.com                          
    rhoAir = 1.2041;            % Density of air (kg/m^3) sea level from wikipedia 
    k = 0.41;                   % Von Karmen constant         
    g = 9.80665;                % Acceleration due to gravity (m/s^2) by convention 
    z0 = 4/30;                  % Roughness Length D/30

% Declare
particleArray(3*nParticles) = particle;    % Create array of particles           
totalParticleArray(3*nParticles*mRepetitions) = particle;     % Create concatenated array of particles over multiple model runs 

for i=1:(3*nParticles)                      % Create particles
    particleArray(i) = particle;
end
% debug code
%  particleArray(1).x = 225;
%  particleArray(2).x = 135;
%  particleArray(3).x = 134;

% Model Runs
for i=1:(mRepetitions)
    fprintf('On model run number %f\n',i);
    %try      
        newInitializeBed(particleArray)                  % Place Particles in Bed      

        idTop(particleArray);                 % Identify Top Row of Particles

        ave = averageHeight(particleArray);   % Calculate Average Height of Top Row

        idCFM(particleArray, ave);            % Identify Canidates For Movement

        assnPivot(particleArray);             % Assign Pivot Point and Moment Arms 
            
        assnLift(particleArray);              % Assign Lift Point (for area exposed to flow)
        
        % Calculate Fluid Threshold Shear Velocity For Each Particle
        solveUft(particleArray,Cd,k,rhoAir,rhoSand,g,z0,ave); 
        
        NormalizeMomentArms(particleArray);  % Normalize Moment Arms

        P = gatherData(particleArray);        % Make Structure Array to easily view properties
        
        Print(particleArray, ave);           % Print Particle Bed

        % Assimilate particle array into total particle/structure Array for data collection     
            if i==1
                totalParticleArray = particleArray;
                Ptot = P;
            else
                totalParticleArray = [totalParticleArray,particleArray];
                Ptot = [Ptot, P];
            end
    %catch
        %disp('Error')
        %continue
    %end
end
toc
elapsedTime = toc/60;                                           %give run time in seconds and minutes
fprintf('or %d minutes\n',elapsedTime)
%MODEL STOP
