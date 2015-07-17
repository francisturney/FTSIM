%DATA ANALYSIS 
%extract data from P into variable mG, mD and uft
N = 448;             % Size of Pto\

% for i=1:N
%     if Ptot(i).CFM
%         Ptot(i).mG = Ptot(i).mG/Ptot(i).r;
%         Ptot(i).mD = Ptot(i).mD/Ptot(i).r;
%     end
% end    
mG=[];
mD=[];
nCFM=0;
uft=0;
radii = [];
radiusTot = [];
for i=1:N
    radiusTot(i) = Ptot(i).r;  
    if Ptot(i).CFM          
        if ~isreal(Ptot(i).uft) || (Ptot(i).uft >7)                             %Elimintae outliers
            continue
        end
        nCFM = nCFM + 1;                            %indicies for new array for histogram
        %mG(topNumber) = Ptot(i).mG;                        
        %mD(topNumber) = Ptot(i).mD;                       
        uft(nCFM) = Ptot(i).uft;
        radii(nCFM) = Ptot(i).r; 
    end
end
hist(uft,50)
title('Histogram of u_{*_{ft}} for D_{R} = (2-6)')
xlabel('Fluid Threshold Shear Velocity (m/s)')
ylabel('Frequency out of aproximatly 1000')
min(uft)
% edges = logspace(-1,0,101);
% centerBins = geomean([edges(1:end-1);edges(2:end)])
% xbins = 0:0.1:3.5
% [M,X] = hist(uft, centerBins)
% bar(X(2:end),M(2:end))