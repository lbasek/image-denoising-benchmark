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
randn('seed',0);

fn               =    'Data\Denoising_test_images\house.tif';     
dict             =    2; 
noise_levels     =    [5, 10, 15, 20, 50, 100];
nSig             =    noise_levels( 4 );

par              =    Parameters_setting( nSig );
par.I            =    double( imread( fn ) );
par.nim          =    par.I + nSig*randn(size( par.I ));
    
[im PSNR SSIM]   =    NCSR_Denoising( par );    

imwrite(im./255, 'Results\NCSR_den_house.tif');
disp( sprintf('%s: PSNR = %3.2f  SSIM = %f\n', House, PSNR, SSIM) );



 