function P = gatherData(P,particleArray,nParticles)
    nDummies = 2*nParticles;
    for i=1:nParticles + nDummies
        P(i).x = particleArray(i).x;
        P(i).z = particleArray(i).z;
        P(i).r = particleArray(i).r;
        P(i).center = particleArray(i).center;
        P(i).top = particleArray(i).isTop;
        P(i).CFM = particleArray(i).isCFM;
        P(i).mD = particleArray(i).dragMomentArm;
        P(i).mG = particleArray(i).gravityMomentArm;
        if P(i).CFM == true;
            P(i).uft = struct('log', 0, 'linear', 0, 'logMod', 0, 'linMod', 0);
            P(i).uft.log = particleArray(i).uft(1);  P(i).uft.linear = particleArray(i).uft(2);
            P(i).uft.logMod = particleArray(i).uft(3);  P(i).uft.linMod = particleArray(i).uft(4);
        end
        P(i).pivPoint = particleArray(i).pivotPoint;
        P(i).liftPoint = particleArray(i).liftPoint;
        P(i).wake = particleArray(i).wake;
        P(i).ave = particleArray(i).ave;
        P(i).I = particleArray(i).I;
        P(i).lift = particleArray(i).lift;
        P(i).pivot = particleArray(i).pivot;
        if P(i).z == 0; P(i).destroyed = 1; end;
    end
end