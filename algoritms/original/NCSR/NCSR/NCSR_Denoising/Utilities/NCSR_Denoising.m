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
function [im_out PSNR SSIM ]   =  NCSR_Denoising( par )
nim           =   par.nim;
[h  w ch]     =   size(nim);
par.step      =   1;
par.h         =   h;
par.w         =   w;
dim           =   uint8(zeros(h, w, ch));
ori_im        =   zeros(h,w);

if  ch == 3
    n_im           =   rgb2ycbcr( uint8(nim) );
    dim(:,:,2)     =   n_im(:,:,2);
    dim(:,:,3)     =   n_im(:,:,3);
    n_im           =   double( n_im(:,:,1));
    
    if isfield(par, 'I')
        ori_im         =   rgb2ycbcr( uint8(par.I) );
        ori_im         =   double( ori_im(:,:,1));
    end
else
    n_im           =   nim;
    
    if isfield(par, 'I')
        ori_im             =   par.I;
    end
end
disp(sprintf('PSNR of the noisy image = %f \n', csnr(n_im(1:h,1:w), ori_im, 0, 0) ));

[d_im]     =   Denoising(n_im, par, ori_im);


if isfield(par,'I')
   [h w ch]  =  size(par.I);
   PSNR      =  csnr( d_im(1:h,1:w), ori_im, 0, 0 );
   SSIM      =  cal_ssim( d_im(1:h,1:w), ori_im, 0, 0 );
end

if ch==3
    dim(:,:,1)   =  uint8(d_im);
    im_out       =  double(ycbcr2rgb( dim ));
else
    im_out  =  d_im;
end
return;


function  [d_im ]    =   Denoising(n_im, par, ori_im)
[h1 w1]     =   size(ori_im);

par.tau1    =   0.1;
par.tau2    =   0.2;
par.tau3    =   0.3;
d_im        =   n_im;
lamada      =   0.02;
v           =   par.nSig;
cnt         =   1;

for k    =  1:par.K

    Dict          =   KMeans_PCA( d_im, par, par.cls_num );
    [blk_arr, wei_arr]     =   Block_matching( d_im, par);
    
    for i  =  1 : 3
        d_im    =   d_im + lamada*(n_im - d_im);
        dif     =   d_im-n_im;
        vd      =   v^2-(mean(mean(dif.^2)));
        
        if (i ==1 && k==1)
            par.nSig  = sqrt(abs(vd));            
        else
            par.nSig  = sqrt(abs(vd))*par.lamada;
        end
        
        [alpha, beta, Tau1]   =   Cal_Parameters( d_im, par, Dict, blk_arr, wei_arr );   
        
        d_im        =   NCSR_Shrinkage( d_im, par, alpha, beta, Tau1, Dict, 1 );

        PSNR        =   csnr( d_im(1:h1,1:w1), ori_im, 0, 0 );
        fprintf( 'Preprocessing, Iter %d : PSNR = %f,   nsig = %3.2f\n', cnt, PSNR, par.nSig );
        cnt   =  cnt + 1;
        imwrite(d_im./255, 'Results\tmp.tif');
    end
end
