function [imout fft_h] = Generate_blur_image(im, Blur_type, Blur_par, nSig, seed)

[h w ch] =  size(im);

if Blur_type==1
    psf      =  ones(Blur_par)/(Blur_par*Blur_par);
    fft_h    =  zeros(h,w);
    t        =  floor( size(psf,1)/2 );
    fft_h(h/2+1-t:h/2+1+t,w/2+1-t:w/2+1+t)  = psf;
    fft_h    =  fft2(fftshift(fft_h));    
else

    psf=fspecial('gaussian', 25, Blur_par);
    fft_h    =  zeros(h,w);
    t        =  floor( size(psf,1)/2 );
    fft_h(h/2+1-t:h/2+1+t,w/2+1-t:w/2+1+t)  = psf;
    fft_h    =  fft2(fftshift(fft_h));        
    
end

if ~exist('seed'),
    seed = 0;
end    
randn('seed',seed);


imout   =  zeros( size(im) );
if ch==3
    for i = 1 : 3
        im_f    =  fft2(im(:,:,i));
        z_f     =  fft_h.*im_f;
        z       =  real(ifft2(z_f));
        imout(:,:,i)    =  z;
    end
else
    im_f    =  fft2(im);
    z_f     =  fft_h.*im_f;
    z       =  real(ifft2(z_f));
    imout   =  z;
end
    
imout   =  imout + nSig*randn(size(im));
