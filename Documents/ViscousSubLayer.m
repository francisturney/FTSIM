% Viscous Sublayer and Fluid Threshold Equations

% Planetary Physical Properties @ sea level  
    rhoAirEarth = 1.225;                 % Density of air on Earth kg/m^3 (Murilo, 2008) 
    rhoAirMars = 0.02;                   % Density of air on Mars  kg/m^3 ...
    rhoAirTitan = 5.1;                   % Density of air on Titan kg/m^3 
    rhoPEarth = 2650;                    % Density of average particles on Earth kg/m^3 (Murilo, 2008) 
    rhoPMars = 3200;                     % Density of average particles on Mars  kg/m^3 ...
    rhoPTitan = 1000;                    % Density of average particles on Titan  kg/m^3 ...
    sigmaPEarth = rhoPEarth/rhoAirEarth; % Particle to fluid density ratio
    sigmaPMars = rhoPMars/rhoAirMars;    % Particle to fluid density ratio
    sigmaPTitan = rhoPTitan/rhoAirTitan; % Particle to fluid density ratio
    muAirEarth = 1.78e-5;                % Dynamic viscoisty of air on Earth kg/ms  
    muAirMars = 1.3e-5;                  % Dynamic viscosity of air on Mars kg/ms
    muAirTitan(1) = 1.8325e-4*(416.16/(94 + 120))*(94/296.16)^(1.5); % Roe 2002 (Titan's CLouds from Gemini)
    muAirTitan(2) = 4.489e-5;            % Rishbeth 1999 Dynamics of Titan's thermosphere
    gEarth = 9.81;                       % Gravity on Earth
    gMars = 3.71;                        % Gravity on Mars
    gTitan = 1.352;                      % Gravity on Mars
    aveDpEarth = 250e-6;                 % Average particle diameters involved in saltation on Earth
    aveDpMars = 600e-6;                  % Average of particle diameters involved in saltation on Mars
    aveDpTitan = 300e-6;                 % Average of particle diameters involved in saltation on Titan
    An = 0.0123;                         % Emperical constant from Shao and Lu 2000
    gamma = 10e-4;                       % Emperical constant from Shao and Lu 2000
    
 % Fluid Threshold Equations for average particle on planet, from Shao and Lu, 2000
    uft =  struct('Earth', 0, 'Mars', 0, 'Titan', 0);
    uft.Earth = sqrt(An*(sigmaPEarth*gEarth*aveDpEarth + gamma/(rhoAirEarth*aveDpEarth))); % Fluid Threshold for the avereage Earth particle
    uft.Mars = sqrt(An*(sigmaPMars*gMars*aveDpMars + gamma/(rhoAirMars*aveDpMars))); % Fluid Threshold for the avereage Earth particle
    uft.Titan = sqrt(An*(sigmaPTitan*gTitan*aveDpTitan + gamma/(rhoAirTitan*aveDpTitan)));
    
 % Viscous Sublayer Depth for average particle at fluid threshold, from Kok et al 2012
    deltaVis = struct('Earth', 0, 'Mars', 0, 'Titan', 0);
    deltaVis.Earth = (5*muAirEarth)/(rhoAirEarth*uft.Earth);
    deltaVis.Mars = (5*muAirMars)/(rhoAirMars*uft.Mars);
    deltaVis.Titan = (5*(muAirTitan(1) + muAirTitan(2))/2)/(rhoAirTitan*uft.Titan);