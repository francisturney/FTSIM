function P = areaExp(P,N) %CALCULATES THE AREA EXPOSED OF ALL THE PARTICLES IN THE ARRAY THROUGH INTEGRAL TO ANTI-PIVOT POINT
import bedGeometry.*        % Package of functions controlling bed Geometry

    [P.expArea]=deal(0);                     %add exposed area to P feild
    for i=1:N
        if P(i).top
           P(i).expArea = pi*P(i).r.^2;                                  
           P(i).expArea = P(i).expArea + pi*P(i).r*sqrt(P(i).r.^2 - (P(i).x - P(i).antiPivPoint(1)).^2);  
        end
    end
end