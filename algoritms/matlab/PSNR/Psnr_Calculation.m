%This program calculates the PSNR value for the denoised image found in demo.

Denoised_Image = double(imread('Img0722Noisy.bmp'));

Reference_Image = double(imread('Img0722Ref.bmp'));
Clean_Image = double(imread('Img0722Clean.bmp'));

value = SigmaNoisy(Reference_Image,Denoised_Image,Clean_Image);

PSNR = 20*log10(255/value(:,4));

sprintf('The sigma value calculated is %g.', value(:,4))
sprintf('The PSNR value is %g.', PSNR)
