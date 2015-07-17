function [] = allign(particleArray,j)                       % Align particles on surface after overlap from collision
import bedGeometry.*                                % Package of functions controlling bed Geometry
jthParticle = particleArray(j);                     % More readable notation
jTouched = particleArray(particleArray(j).touching);  % Particle that jth particle is touching
LR = jthParticle.LR;                                % Left/Right coeficient (-1) for left (+1) for right    

    theta = asin((jthParticle.z - jTouched.z)/pdist([jthParticle.center; jTouched.center],'euclidean'));     % theta is the angle of impact axis against horizontal
    r2 = jthParticle.r + jTouched.r;                                                        %distance new distance between center of particles
    z = jTouched.z + r2*sin(theta);
    x = jTouched.x + LR*r2*cos(theta);
    move(particleArray,j,x,z);
end