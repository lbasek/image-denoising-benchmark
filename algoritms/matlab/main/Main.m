
%BatchPath = '/Users/lbasek/image-denoising-benchmark/dataset/batch5';
BatchPath = '../../../dataset/batch2';

addpath(genpath('../FOE'));
addpath(genpath('../PSNR'));

% Read images
Noisy_Image = imread(strcat(BatchPath , '/noisy.bmp')); 
Reference_Image = imread(strcat(BatchPath ,'/reference.bmp'));
Clean_Image = imread(strcat(BatchPath , '/clean.bmp'));

% PSNR before
value = SigmaNoisy(double(Reference_Image),double(Noisy_Image),double(Clean_Image));
PSNR = 20*log10(255/value(:,4));
sprintf('The PSNR value is %g.', PSNR)

% Sigma 5, 10, 15, 20, 25, 50

% Denoised_Image= BM3D(strcat(Batch_01 , '/noisy.bmp'),25);
% Denoised_Image = KSVD_WRAP(strcat(Batch_01 , '/noisy.bmp'),10);
% Denoised_Image = WNNM_WRAP(strcat(Batch_01 , '/noisy.bmp'),10);
Denoised_Image = FOE_WRAP(strcat(BatchPath , '/noisy.bmp'), 10);

% Show images
figure; imshow(Noisy_Image);   
figure; imshow(Denoised_Image);

% PSNR after
value = SigmaNoisy(double(Reference_Image),double(Denoised_Image),double(Clean_Image));
PSNR = 20*log10(255/value(:,4));
sprintf('The PSNR value after denoising is %g.', PSNR)


