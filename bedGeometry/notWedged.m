function notWedged = notWedged(P,i)
    notWedged = true; 
    if (P(i).touching == 0) || (P(i).landing == 0);
        return
    end
    if ((P(i).x < P(P(i).touching).x) && (P(i).x > P(P(i).landing).x)) || ((P(i).x > P(P(i).touching).x) && (P(i).x < P(P(i).landing).x))
        notWedged = false;
    end
        
        