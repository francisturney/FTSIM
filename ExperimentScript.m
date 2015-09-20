% ExperimentScript


% USER INPUTS
    nParticles = 100;            % Number of particles per bed formation
    lBound = 100;                % Lower bound
    range = 100;                 % Range of placement
    mRepetitions = 300;            % Number of model runs, i.e. number of times a bed is created and data colected on it, 300 represents 1000 CFM (100 particles)
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
    Beta = 10^(-4);              % Coeficient for interparticle cohesion, 10^-4 from Shao and Lu, 2000, 0.0012 from Corn 1961
    
    
dataPoint = 15;
stats(dataPoints) = struct('L', 0, 'H', 0, 'meanDp', 0 ,'stdDevDp', 0, 'Dp10', 0,...
                   'meanUft', [], 'stdDevUft', [], 'uft10', [], 'uft90', []);

               
for i=1:dataPoints
    stats(i) = Main(
end