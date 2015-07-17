%RUN MODEL MULTIPLE TIMES
% Main
% Ptot = P;
tic
for i=1:(400)
    fprintf('On model run number %f\n',i);
    try
        Main
        
        if i=1;
            Ptot = P;
        else
        Ptot = [Ptot,P];
    catch
        continue
    end
end
toc
elapsedTime = toc/60;                                           %give run time in seconds and minutes
fprintf('or %d minutes\n',elapsedTime)