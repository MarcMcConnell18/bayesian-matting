function [CovF, CovB] =  MathComputation (Fground, Bground, image)
    %get input data of image
    img_data = Imread(image);
    
    %calculating mean value of F, B, image
    for i = 1 : 3
       Fmean = mean(Fground(:, :, i));
       Bmean = mean(Bground(:, :, i));
       Imgmean = mean(img_data(:, :, i));
    end   
    %initialize the covariance of F and B
    covF = [0 0 0; 0 0 0; 0 0 0];
    covB = [0 0 0; 0 0 0; 0 0 0];

    %set counting number of F and B
    Count_F = 0;
    Count_B = 0;
    %get w and h from image
    width = size(img_data, 1);
    height = size(img_data, 2);
    %calculate the covariance value of F, B, Image
  for b = 1 : height
     for a = 1 : width
        
        if any(Fground(a,b,:))
            shiftF = [ (Fground(a,b,1)-Fmean(1))  (Fground(a,b,2)-Fmean(2))  (Fground(a,b,3)-Fmean(3)) ];
            covF = covF +(shiftF' * shiftF);
            Count_F = Count_F +1;
        end
        if any(Bground(a,b,:))
            shiftB = [ (Bground(a,b,1)-Bmean(1))  (Bground(a,b,2)-Bmean(2))  (Bground(a,b,3)-Bmean(3)) ];
            covB = covB + (shiftB' * shiftB);     
            Count_B = Count_B +1;
        end
     end
  end
 CovF = covF / Count_F;
 CovB = covB / Count_B;
 
 img_data = double(img_data);
 for b=1:height
     for a=1:width
          temp = temp +((img_data(a,b,1)- Imgmean(1))^2 + (img_data(a,b,2)- Imgmean(2))^2 + (img_data(a,b,3)- Imgmean(3))^2);
     end
 end
end