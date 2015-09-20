function stats = dataAnalysis(stats, P, nParticles, mRepetitions, range, meanParticleDiameter, stdDeviation)

    stats.uft = struct('log', 0, 'linear', 0, 'logMod', 0, 'linMod', 0); % Declare structure as a feild within stats array
    stats.uft10 = struct('log', 0, 'linear', 0, 'logMod', 0, 'linMod', 0);
    stats.uft30 = struct('log', 0, 'linear', 0, 'logMod', 0, 'linMod', 0);
    stats.uft50 = struct('log', 0, 'linear', 0, 'logMod', 0, 'linMod', 0);
    
    
    nTops = 0;
    uft = 0;
    nCFMs = 0;
    for i=1:mRepetitions                    % For Each Model Run
        ave(i) = P(i,1).ave;
        
        for j=1:nParticles*3                                % For Each Simulation Gather accurate uft array and heights              
            if P(i,j).CFM == true  
                    if (P(i,j).uft.log > 3.5) || (P(i,j).uft.linear > 3.5) || (P(i,j).uft.logMod > 3.5) || (P(i,j).uft.linMod > 3.5)   % Elimintae outliers
                        continue                            % Outliers
                    end   
               
                nCFMs = nCFMs + 1;                          % Counting number of nCFMss        
                stats.uft(nCFMs) = P(i,j).uft;              % Move uft feild from P to stats
                stats.DpCFM(nCFMs) = (2*P(i,j).r/10)*(meanParticleDiameter/0.8); % nCFMs particle stats
            end
            if P(i,j).top == true                           % Gather heights above average for test 
                nTops = nTops + 1;
                stats.heights(nTops) = P(i,j).z - ave(i);
            end
        end
        stats.nCFMs = nCFMs;
    end
    ave = mean(ave);
        % Sensitivity Test Parameters
            stats.L = range/(meanParticleDiameter*10);      % Non dimensionalized range of placement in x
            stats.H = ave/(meanParticleDiameter*10);        % Non dimensionalized average height of the bed
        
        % uft distribution stats  
            % Vectorize 
                log = [stats.uft.log];
                linear = [stats.uft.linear];
                logMod = [stats.uft.logMod];
                linMod = [stats.uft.linMod];
                
                DpCFM = [stats.DpCFM];
            
            % Percentiles of uft distribution   
                stats.uft10.log = prctile(log,10);
                stats.uft10.linear = prctile(linear,10);
                stats.uft10.logMod = prctile(logMod,10);
                stats.uft10.linMod = prctile(linMod,10);
                
                stats.uft30.log = prctile(log,30);
                stats.uft30.linear = prctile(linear,30);
                stats.uft30.logMod = prctile(logMod,30);
                stats.uft30.linMod = prctile(linMod,30);
                
                stats.uft50.log = prctile(log,50);
                stats.uft50.linear = prctile(linear,50);
                stats.uft50.logMod = prctile(logMod,50);
                stats.uft50.linMod = prctile(linMod,50);
                
                stats.uft60.log = prctile(log,60);
                stats.uft60.linear = prctile(linear,60);
                stats.uft60.logMod = prctile(logMod,60);
                stats.uft60.linMod = prctile(linMod,60);
                
             % Particle Properties
                stats.meanDp = meanParticleDiameter;
                stats.stdDevDp = stdDeviation;
             
             % Percentiles of CFM distribution
                stats.Dp10CFM = prctile(DpCFM,10);
                stats.Dp30CFM = prctile(DpCFM,30);
                stats.Dp50CFM = prctile(DpCFM,50);
                stats.Dp60CFM = prctile(DpCFM,60);        

end