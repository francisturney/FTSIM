function P = solveUft(P,N,ave)
    %SOLVE FOR uft FLUID THRESHOLD SHEAR VELOICTY*
        [P.uft]=deal(0);            %make initialize uft feild
        rhoAir = 1.2041;            %density of air (kg/m^3) sea level from wikipedia
        rhoSand = 2650;             %density of quarts sand (kg/m^3) taken from midpoint of top and bottom values on engineeringtoolbox.com             
        Kd = 4.7;                    %dimensionless coeficent assosiated with the drag force
        k = 0.41;                   %von karmen constant 
        g = 9.80665;                %acceleration due to gravity (m/s^2) by convention 
        Itop = 0;                   %top half of integral (top windward quadrant)
        Ibot = 0;                   %integral for bottown windward quadrant            
        z0 = ave;                   %height at which wind speed goes to 0 in law of wall
    %CALULATE U FLUID THRESHOLD FROM MOMENT BALANCE OF DRAG AND GRAVITY FORCES
    for i=1:N
        if P(i).top
            %CALULATION OF DRAG FORCE 
            %CALCULATE INTEGRAL OF WIND SPEED AND EXPOSED AREA (I)
            P(i).I = 0;             %integral of wind and area per particle
            f = @(z) (log(z./z0)).^2.*(abs(z-P(i).y)./sqrt(P(i).r.^2 - (z-P(i).y).^2));     %integrand
            if P(i).y <= z0
                P(i).top = false;   %if below avergae height then dont count as a top particle anymore
            else
                %NUMERICAL INTEGRATION USING GLOBAL ADAPTIVE QUADRATURE AND DEFAULT ERROR TOLERANCES
                    Itop = integral(f,P(i).y,P(i).y+P(i).r);    %calulate top half of integral (top windward quadrant)
                if (P(i).y - P(i).r) < z0                       %then claculate bottown windward quadrant based on antiPivPoint and z0 
                    Ibot = integral(f,z0,P(i).y);               %if particle dips below z0 then integrate upwards from z0
                else
                    Ibot = integral(f,P(i).antiPivPoint(2),P(i).y);      %else integrate upwards from anti-pivot point
                end
                P(i).I = Itop + Ibot;                           %add integrals to get total integral
                %solve for threshold shear velocity (conversion step)
                P(i).uft = sqrt((rhoSand - rhoAir)*g*(P(i).r*2/10000)^3*k^2*P(i).mG/(P(i).mD*6*Kd*(P(i).I/10000)*(P(i).r/10000)));  %factors of ten are conversion factors between hectomicrons and meters (I is meters squared)
            end

        end
    end
end