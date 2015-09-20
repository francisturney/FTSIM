%clean data
for i = 1:16700
    if Ptot(i).top
        Ptot(i).uft = Ptot(i).uft*sqrt((2650 - 1.2041)/(1400 - 1.2041))
    end
end