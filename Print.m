function Print(P, nParticles, range)
    ave = P(1).ave;
    nDummies = 2*nParticles;
    N = nParticles + nDummies;
    clf
    figure(1)
    %ax = axes; hold on;
    % Draw Particles in Red
    c = 1/10; % Conversion to mm
    for i=1:N                                                       %Print to screen
        viscircles(c*P(i).center,c*P(i).r,'EdgeColor','k');
        
        % Draw Top Row of Particles in Blue
        if P(i).isTop == true 
            viscircles(c*P(i).center,c*P(i).r,'EdgeColor','b'); 
        end
        % Draw Pivot Points in Blue
        hold on
        if P(i).isCFM
            % Draw point
            plot(c*P(i).pivotPoint(1),c*P(i).pivotPoint(2),'k.', 'MarkerSize',20);
            
            % Draw lever arms
            if (P(i).pivotPoint ~= 0)
                lineX = [c*P(i).x; c*P(i).pivotPoint(1)];
                lineY = [c*P(i).z; c*P(i).pivotPoint(2)];
                line(lineX,lineY,'Color','k');
            end
        % Draw Anti Pivot Points in Blue
            viscircles(c*P(i).liftPoint,c*0.5, 'EdgeColor', 'b');          %Removed
        end
    end
    for i=1:N
        if P(i).isCFM
           if P(i).wake ~= 0
                viscircles(c*P(P(i).wake).center,c*P(P(i).wake).r,'EdgeColor', 'r');
           end
        end
    end
    % Draw Average Height in Dashed Black Line
    x = linspace(c*30,c*(range + 2*range),100);
    z = linspace(c*ave,c*ave,100);
    plot(x,z,'--k','LineWidth', 1);
    
title('Modeled Particle Bed for Mean Diameter 0.8mm', 'FontSize', 20, 'FontName', 'Times')
%axes('FontSize', 14, 'FontName', 'Times');
xlabel('distance(mm)','FontSize',20,...
       'FontName','Times');
ylabel('height(mm)','FontSize',20,...
       'FontName','Times');
    r = range/10 - 0.2*range/10;
    a = ave/10 + 0.25*ave/10;
    % Conditions for equal frame (solve for b) : (a + b) - (a - b) = 2r - r  
    axis([r, 2*r, a - r/2, a + r/2])
    axis equal
end