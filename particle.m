% Class: particle
% Description: particles represent sand grains and are essentially 2D circles which hold 
% properties about their physics and points of contact with neighbors
classdef particle < handle
    properties
        % Particle Geometry and Forces
        r                       % Radius of assumed circular particle
        x                       % X coordinate of particle
        z                       % Z coordinate of particle
        center = [0,0]          % 2D particle center loctation for Matlab functions
        accel = [0,0,-9.8]      % 3D acceleration on a particle's center of mass
        dragMomentArm           % Moment arm that the drag force works on
        gravityMomentArm        % Moment arm the gravity works on
        uft                     % Fluid Threshold Shear Veloicty
        
        % Indicies of adjacent particles and orientation
        isTop = false           % True/False for member of top row of particles in bed
        isCFM = false           % Canidate For Movement
        touching = 0;           % Particle that the jth particle has landed on
        landing = 0;            % Particle that the jth particel will land on
        prevTouch = 0;          % Pouching particle from previous loop  
        LR = 0;                 % Particle oriantation coeficint: (-1) for left (1) for right
        pivotPoint = [0,0]      % Location of pivot point (considering a left to right wind)
        liftPoint  = [0,0]      % Point opposite from the pivot point that the particle lifts off
        dummyIndex = 0;         % Index of created dummy particle which mirrors the ith particle 
        dummyFriend = 0;        % Index of the particle that created the dummy particle
       
    end
    methods
        % Constructor
        function particle = particle(radius, stdDeviation)                 % Constructor
            if  nargin == 0
                m=4; % Mean for lognormal distribution 
                s=1; % Standard deviation for normal lognormal distribution
                mu = log(m^2/sqrt(s+m^2));
                sigma = sqrt(log(1+s/m^2));
                particle.r = lognrnd(mu,sigma);                                                %  Particle radius  
                particle.x = (130 + particle.r) + (100 - particle.r).*rand(1);                          % x coordinate of center                                         
                particle.z = 200;                                           % z coordinate of center
                particle.center = [particle.x,particle.z];   
            end
        end
        
        function [] = change(particleArray)
            particleArray(1).r = 0;
        end
%         function particle = move(particle, timeStep)
%            if particle.accel ~= [0,0,0];
%                
%            end
%         end
    end
    methods (Static)
        function text = secondCommand()
           text = 'secondCommand'; 
        end
    end
    
end
