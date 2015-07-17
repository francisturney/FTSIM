%DATA ANALYSIS 
%extract data from P into variable mG, mD and uft
N = 50;             %Psudeo Size for whatever matrix we are working with 
mG=[];
mD=[];
windSpeed=[];
topNumber=0;
uft=[];
radii = [];
radiusTot = [];
for i=1:N
    radiusTot(i) = Ptot(i).r;  
    if Ptot(i).top          
        if ~isreal(Ptot(i).uft) || (Ptot(i).uft > 3.5)   %Elimintae outliers
            continue
        end
        topNumber = topNumber+1;                       %indicies for new array for histogram
        mG(topNumber) = Ptot(i).mG;                        
        mD(topNumber) = Ptot(i).mD;                       
        uft(topNumber) = Ptot(i).uft;
        windSpeed(topNumber) = (uft(topNumber)./0.41).*log(1/(0.0001/30));
        radii(topNumber) = Ptot(i).r; 
    end
end

%CREATE DISTRIBUTION OBJECTS
A = 0;
B = 0;
[f, x] = hist(windSpeed,50);                             %create histogram and centers
[PARMHAT,PARMCI] = lognfit(uft);                    %get shape and scale parameters for gama distribution                     
y = lognpdf(x,PARMHAT(1),PARMHAT(2));               %create gama pdf

[gammaHAT,gammaCI] = gamfit(uft);                   %get shape and scale parameters for gama distribution                     
y2 = gampdf(x,gammaHAT(1),gammaHAT(2));             %create gama pdf
ksTest = kstest2(f/trapz(x,f),y)                    %Two-sample Kolmogorov-Smirnov test
sum(2*f/trapz(x,f))

%FIND INFLECTION POINT
A = [0 diff(y)];
B = [0 diff(A)];
Result = find(B(1:end-1).*B(2:end)<0)
inflec = Result(1);
uftInflec = (x(inflec) + x(inflec+1))/2