function psnr = PSNR(Reference_Image, Clean_Image, Noisy_Image)

value   = SigmaNoisy(double(Reference_Image),double(Noisy_Image),double(Clean_Image));
psnr    = 20*log10(255/value(:,4));