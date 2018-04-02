% =========================================================================
% NCSR for image denoising, Version 1.0
% Copyright(c) 2013 Weisheng Dong, Lei Zhang, Guangming Shi, and Xin Li
% All Rights Reserved.
%
% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is here
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%----------------------------------------------------------------------
%
% This is an implementation of the algorithm for image interpolation
% 
% Please cite the following paper if you use this code:
%
% Weisheng Dong, Lei Zhang, Guangming Shi, and Xin Li.,"Nonlocally  
% centralized sparse representation for image restoration", IEEE Trans. on
% Image Processing, vol. 22, no. 4, pp. 1620-1630, Apr. 2013.
% 
%--------------------------------------------------------------------------
clc;
clear;

fn                 =    'Data\SR_test_images\Butterfly.tif';     
psf                =    fspecial('gauss', 7, 1.6);
scale              =    3;
nSig               =    0;

par                =    NCSR_SR_Par( nSig, scale, psf );
par.I              =    double( imread( fn ) );
LR                 =    Blur('fwd', par.I, psf);
LR                 =    LR(1:par.scale:end,1:par.scale:end,:);    
par.LR             =    Add_noise(LR, nSig);   
par.B              =    Set_blur_matrix( par );  
    
[im PSNR SSIM]     =    NCSR_Superresolution( par );     
disp( sprintf('%s :  PSNR = %2.2f  SSIM = %2.4f\n\n', fn, PSNR, SSIM));

if nSig == 0       
    imwrite(im./255, 'Results\SR_results\Noiseless\NCSR_Butterfly.tif');
else
    imwrite(im./255, 'Results\SR_results\Noisy\NCSR_Butterfly.tif');
end




