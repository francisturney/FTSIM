%Plot distribution
A = 0;
B = 0;
[f, x] = hist(uft,100);                              %create histogram and centers
[PARMHAT,PARMCI] = lognfit(uft);                    %get shape and scale parameters for gama distribution                     
y = lognpdf(x,PARMHAT(1),PARMHAT(2));               %create gama pdf

[gammaHAT,gammaCI] = gamfit(uft);                    %get shape and scale parameters for gama distribution                     
y2 = gampdf(x,gammaHAT(1),gammaHAT(2));               %create gama pdf

%histfit(uft,50,'gamma'); hold on

bar(x,f/trapz(x,f)); hold on                      %divide by area to normalize
plot(x,y,'g');
plot(x,y2,'r');
xlabel('Fluid Threshold Shear Velocity (m/s)')
ylabel('Probability Density Function')
hold off
ksTest = kstest2(f/trapz(x,f),y)                        %Two-sample Kolmogorov-Smirnov test

%FIND INFLECTION POINT
A = [0 diff(y)];
B = [0 diff(A)];
Result = find(B(1:end-1).*B(2:end)<0)
inflec = Result(1);
uftInflec = (x(inflec) + x(inflec+1))/2

Xsize = size(x);
%chiSqrd = chi2gof(Xsize(2),'Ctrs',Xsize(2),...
%                        'Frequency',f/trapz(x,f), ...
%                        'Expected',y,...
%                        'NParams',1)

