function [Fg_Covf, Bg_Covf, Bmean, Fmean] =  MathComputation (Fground, Bground, Bweight, Fweight)

    %sum the weight of Background and Foreground
    
    Bg_weight = sum(Bweight);
    Fg_weight = sum(Fweight);

    %calculating mean value of F, B, image
    for i = 1 : 3
       Fmean(i) = (sum(Fground(i, :).* Fweight))./ Fg_weight;
       Bmean(i) = (sum(Bground(i, :).* Bweight))./ Bg_weight;
    end   

    %calculate the covariance value of F, B, Image

            shiftF = [ (Fground(1, :)-Fmean(1)) ; (Fground(2, :)-Fmean(2)) ; (Fground(3, :)-Fmean(3)) ];
            Fg_Covf = ((Fweight .* shiftF) * shiftF') / Fg_weight;
 
            shiftB = [ (Bground(1, :)-Bmean(1)) ; (Bground(2, :)-Bmean(2)) ; (Bground(3, :)-Bmean(3)) ];
            Bg_Covf = ((Bweight .* shiftB) * shiftB') / Bg_weight;     


end