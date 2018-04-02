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

fn                 =    'Data\Deblurring_test_images\Butterfly.tif';
blur_type          =    1;          % 1: uniform blur kernel;  2: Gaussian blur kernel; 
if blur_type == 1                   % When blur_type = 1, blur_par denotes the kernel size; When blur_type = 2, blur_par denotes the standard variance of Gaussian kernel
    blur_par       =    9;          % the default blur kernel size is 9 for uniform blur;
else
    blur_par       =    3;          % the default standard deviation of Gaussian blur kernel is 3
end
nSig                    =    sqrt(2);    % The standard variance of the additive Gaussian noise;
par                     =    NCSR_Deblurring_Par( nSig, blur_type );
par.I                   =    double( imread( fn ) );
[par.bim par.fft_h]     =    Generate_blur_image(par.I, blur_type, blur_par, nSig);
[im PSNR SSIM]          =    NCSR_Deblurring( par );

imwrite(im./255, 'Results\NCSR_Deb_butterfly.tif'); 
disp( sprintf('%s: PSNR = %3.2f  SSIM = %f\n\n', fn, PSNR, SSIM) );

