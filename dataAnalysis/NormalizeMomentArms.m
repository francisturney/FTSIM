function particleArray = NormalizeMomentArms(particleArray, nParticles)
   nDummies = 2*nParticles;
   for i=1:nParticles + nDummies
        if particleArray(i).isCFM
            particleArray(i).gravityMomentArm = particleArray(i).gravityMomentArm/particleArray(i).r;
            particleArray(i).dragMomentArm = particleArray(i).dragMomentArm/particleArray(i).r;
        end
   end 
end

