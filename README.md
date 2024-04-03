# Bayesian Matting

### Authors

Jiacheng Li<br/>
Yujie Jia<br/>
Aparna Sujatha Ramdoss<br/>
## Date: 05/04/2024

## Introduction
We have successfully implemented a Bayesian matting algorithm in MATLAB and Python, along with supporting functions such as extractNeighborhoodInfo, TransformMatrix, TransformPixels, likelihoodEstimation, and Mathcomputation. In our main script, we utilized these functions to process the original image, trimap, and ground truth data. Our process involved performing foreground-background (FB) split, generating alpha matte, and refining the foreground with the new background estimation.<br/>
Furthermore, we conducted a comparative study between Bayesian matting and Laplacian matting techniques in MATLAB. We also performed Bayesian matting in Python with the given dataset while one part of the project had ground truth and another was the visual benchmark. To evaluate the performance of our implementation, we employed two key performance metrics: Peak Signal-to-Noise Ratio (PSNR), Mean Squared Error (MSE) and Structural Similarity Index Measure(SSIM).<br/>


## Requirements
numpy==1.26.4<br/>
scipy==1.12.0<br/>
opencv-python==4.9.0.80<br/>
matplotlib==3.8.3<br/>
scikit-image==0.22.0<br/>
alive-progress==3.1.5<br/>

## Reference

Chuang, Yung-Yu, et al. "A bayesian approach to digital matting." Proceedings of the 2001 IEEE Computer Society Conference on Computer Vision and Pattern Recognition. CVPR 2001. Vol. 2. IEEE, 2001.<br/>

Sindeyev, Mikhail, Vadim Konushin, and Vladimir Vezhnevets. "Improvements of Bayesian matting." proc. of Graphicon. 2007.<br/>

Azencott, Robert. "Image analysis and Markov fields." Proc. ICIAM’87 (1988): 53-61.<br/>

## License
Trinity College Dublin © 2024
