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
function [im_out PSNR SSIM]   =  NCSR_Superresolution( par )
par.step      =   2;
par.win       =   6;
par.cls_num   =   64;
par.s1        =   25;
par.hp        =   75;

s             =   par.scale;
lr_im         =   par.LR;
[lh lw ch]    =   size(lr_im);
hh            =   lh*s;
hw            =   lw*s;
hrim          =   uint8(zeros(hh, hw, ch));
ori_im        =   zeros(hh,hw);

if  ch == 3
    lrim           =   rgb2ycbcr( uint8(lr_im) );
    lrim           =   double( lrim(:,:,1));    
    b_im           =   imresize( lr_im, s, 'bicubic');
    b_im2          =   rgb2ycbcr( uint8(b_im) );
    hrim(:,:,2)    =   b_im2(:,:,2);
    hrim(:,:,3)    =   b_im2(:,:,3);
    if isfield(par, 'I')
        ori_im         =   rgb2ycbcr( uint8(par.I) );
        ori_im         =   double( ori_im(:,:,1));
    end
else
    lrim           =   lr_im;
    
    if isfield(par, 'I')
        ori_im             =   par.I;
    end
end
hr_im    =   imresize(lrim, s, 'bicubic');
hr_im    =   Superresolution(lrim, par, ori_im, hr_im, 0, 4);
hr_im    =   Superresolution(lrim, par, ori_im, hr_im, 1, 2);

if isfield(par,'I')
   [h w ch]  =  size(par.I);
   PSNR      =  csnr( hr_im(1:h,1:w), ori_im, 0, 0 );
   SSIM      =  cal_ssim( hr_im(1:h,1:w), ori_im, 0, 0 );
end
if ch==3
    hrim(:,:,1)  =  uint8(hr_im);
    im_out       =  double(ycbcr2rgb( hrim ));
else
    im_out  =  hr_im;
end
return;


function  hr_im     =   Superresolution(lr_im, par, ori_im, hr_im0, flag, K)
hr_im      =   imresize( lr_im, par.scale, 'bicubic' );
[h   w]    =   size(hr_im);
[h1 w1]    =   size(ori_im);
y          =   lr_im;
lamada     =   par.lamada;

lam       =   zeros(0);
gam       =   zeros(0);
BTY       =   par.B'*y(:);
BTB       =   par.B'*par.B;
cnt       =   0;
if  flag==1  
     hr_im    =  hr_im0;
end

for k    =  1:K    
    Dict                 =   KMeans_PCA( hr_im, par, par.cls_num );
    [blk_arr wei_arr]    =   Block_matching( hr_im, par); 

    if flag==1
        lam      =   Sparsity_estimation( hr_im, par, Dict, blk_arr, wei_arr );        
    end
    Reg          =   @(x, y)NCSR_Regularization(x, y, par, Dict, blk_arr, wei_arr, lam, flag );
    f            =   hr_im;
    X_m          =   Update_NLM( f, par, blk_arr, wei_arr );
        
    for  iter    =   1 : par.iters
        cnt      =   cnt  +  1;           
        f_pre    =   f;
   
        if (mod(cnt, 40) == 0)
            if isfield(par,'I')
                PSNR     =  csnr( f(1:h1,1:w1), ori_im, 0, 0 );
                fprintf( 'NCSR super-resolution, iter. %d : PSNR = %f\n', cnt, PSNR );
            end
        end

        f        =   f_pre(:);
        for i = 1:par.n
            f    =   f + lamada.*(BTY - BTB*f);
        end
        
        if ( mod(iter, 2)==0 )
            X_m    =  Update_NLM( reshape(f, h,w), par, blk_arr, wei_arr );
        end                
        
        f        =  Reg( reshape(f, h,w), X_m );        
    end
    hr_im   =  f;
end


function  lam     =  Sparsity_estimation( im, par, Dict, blk_arr, wei_arr )
b          =   par.win;
s          =   par.step;
b2         =   b*b;
[h  w]     =   size(im);
PCA_idx    =   Dict.cls_idx;
s_idx      =   Dict.s_idx;
seg        =   Dict.seg;
A          =   Dict.D0;

N         =   h-b+1;
M         =   w-b+1;
r         =   [1:s:N];
r         =   [r r(end)+1:N];
c         =   [1:s:M];
c         =   [c c(end)+1:M];
X0        =   zeros(b*b, N*M);
X_m       =   zeros(b*b,length(r)*length(c),'single');
N         =   length(r);
M         =   length(c);
L         =   N*M;

k    =  0;
for i  = 1:b
    for j  = 1:b
        k        =  k+1;        
        blk      =  im(i:end-b+i,j:end-b+j);
        X0(k,:)  =  blk(:)';
    end
end

idx       =   s_idx(seg(1)+1:seg(2));
set       =   1:size(X_m,2);
set(idx)  =   [];

X_m      =   zeros(length(r)*length(c),b*b,'single');
X        =   X0';

for i = 1:par.nblk
   v             =  wei_arr(set,i);
   X_m(set,:)    =  X_m(set,:) + X(blk_arr(set,i),:) .*v(:, ones(1,b2));
end
X_m      =   X_m';
vu0      =   zeros(b2, L, 'single' );

idx            =   s_idx(seg(1)+1:seg(2));
for  k  =  1 : length(idx)
    i          =   idx(k);
    coe        =   A*( X0(:, blk_arr(i, 1:par.nblk)) - repmat( X_m(:,i), 1, par.nblk ) );
    vu0(:,i)   =   mean(coe.^2, 2);
end

for   i  = 2:length(seg)-1   
    idx            =   s_idx(seg(i)+1:seg(i+1));    
    cls            =   PCA_idx(idx(1));
    P              =   reshape(Dict.PCA_D(:, cls), b2, b2);    
    for  j  =  1 : length(idx)
        k           =   idx(j);
        a           =   P*( X0(:,blk_arr(k, 1:par.nblk)) - repmat( X_m(:, k), 1, par.nblk ));
        vu0(:,k)    =   mean(a.^2, 2);
    end
end
vu0      =   max(0, vu0-par.nSig^2);
lam      =   (par.c1*sqrt(2)*par.nSig^2)./(sqrt(vu0) + par.eps);
return;


