
Batch_01 = '/Users/lbasek/image-denoising-benchmark/dataset/batch8';

% Read images
Noisy_Image = imread(strcat(Batch_01 , '/noisy.bmp')); 
Reference_Image = imread(strcat(Batch_01 ,'/reference.bmp'));
Clean_Image = imread(strcat(Batch_01 , '/clean.bmp'));

% PSNR before
value = SigmaNoisy(double(Reference_Image),double(Noisy_Image),double(Clean_Image));
PSNR = 20*log10(255/value(:,4));
sprintf('The PSNR value is %g.', PSNR)

% Sigma 5, 10, 15, 20, 25, 50
[Noisy, Denoised_Image]= BM3D(strcat(Batch_01 , '/noisy.bmp'),50);

% Show images
figure; imshow(Noisy_Image);   
figure; imshow(Denoised_Image);

% PSNR after
value = SigmaNoisy(double(Reference_Image),double(Denoised_Image),double(Clean_Image));
PSNR = 20*log10(255/value(:,4));
sprintf('The PSNR value after denoising is %g.', PSNR)


