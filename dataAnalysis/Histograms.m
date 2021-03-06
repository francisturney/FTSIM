%DATA ANALYSIS 
%extract data from P into variable mG, mD and uft
N = length(Ptot);             % Size of Pto\

% for i=1:N
%     if Ptot(i).CFM
%         Ptot(i).mG = Ptot(i).mG/Ptot(i).r;
%         Ptot(i).mD = Ptot(i).mD/Ptot(i).r;
%     end
% end    
mG=[];
mD=[];
nCFM1=0; nCFM2=0; nCFM3=0; nCFM4=0;
uft=0; uft1=0; uft2=0; uft3=0; uft4=0;
radii = [];
radiusTot = [];heightDist = [];
% hN = 0;
% heightAbove
for i=1:N
    radiusTot(i) = Ptot(i).r;  
%     if P(i).top == true;
%         hN = hN + 1;
%         heightAbove(hN) = 
%         
    if Ptot(i).CFM          
%         if ~isreal(Ptot(i).uft) || (Ptot(i).uft(1) > 4) || (Ptot(i).uft(2) > 4) || (Ptot(i).uft(3) > 4) || (Ptot(i).uft(4) > 4)                           %Elimintae outliers
%             continue
%         end
%         nCFM = nCFM + 1;                            %indicies for new array for histogram
        %mG(topNumber) = Ptot(i).mG;                        
        %mD(topNumber) = Ptot(i).mD; 
        if (Ptot(i).uft(1) < 4) && isreal(Ptot(i).uft(1))
            nCFM1 = nCFM1 + 1; 
            uft1(nCFM1) = Ptot(i).uft(1);
        end
        if (Ptot(i).uft(2) < 4) && isreal(Ptot(i).uft(2))
            nCFM2 = nCFM2 + 1; 
            uft2(nCFM2) = Ptot(i).uft(2);
        end
        if (Ptot(i).uft(3) < 4) && isreal(Ptot(i).uft(3))
            nCFM3 = nCFM3 + 1; 
            uft3(nCFM3) = Ptot(i).uft(3);        
        end
        if (Ptot(i).uft(4) < 4) && isreal(Ptot(i).uft(4))
            nCFM4 = nCFM4 + 1;
            uft4(nCFM4) = Ptot(i).uft(4);
        end
        %radii(nCFM) = Ptot(i).r; 
    end
end
h = figure;
subplot(2,2,1);
hist(uft1,50)
title('Logrithmic')
xlabel('Fluid Threshold Shear Velocity (m/s)')
ylabel('Frequency out of 881')
axis([0 2 0 300])

subplot(2,2,2)
hist(uft2,50)
title('Linear')
xlabel('Fluid Threshold Shear Velocity (m/s)')
ylabel('Frequency out of aproximatly 1000')
axis([0 2 0 175])

subplot(2,2,3)
hist(uft3,50)
title('Log-modified')
xlabel('Fluid Threshold Shear Velocity (m/s)')
ylabel('Frequency out of aproximatly 1000')
axis([0 2 0 150])

subplot(2,2,4)
hist(uft4,50)
title('Linear-modified')
xlabel('Fluid Threshold Shear Velocity (m/s)')
ylabel('Frequency out of aproximatly 1000')
axis([0 2 0 100])

annotation('textbox', [0 0.9 1 0.1], ...
    'String', 'u_{*_{ft}} for D_{m} = (0.8mm) and sdv = 0.6', ...
    'EdgeColor', 'none', ...
    'FontSize',15, ...
    'HorizontalAlignment', 'center')
%min(uft)
% edges = logspace(-1,0,101);
% centerBins = geomean([edges(1:end-1);edges(2:end)])
% xbins = 0:0.1:3.5
% [M,X] = hist(uft, centerBins)
% bar(X(2:end),M(2:end))