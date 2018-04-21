addpath(genpath('../BM3D'));
addpath(genpath('../FOE'));
addpath(genpath('../KSVD'));
addpath(genpath('../NCSR'));
addpath(genpath('../FOE'));
addpath(genpath('../WNNM'));
addpath(genpath('../PSNR'));
addpath(genpath('../MSE'));
addpath(genpath('../SSIM'));

BatchPath = '../../../dataset/batch12';

NOISY = strcat(BatchPath ,'/noisy.bmp');
REFERENCE = strcat(BatchPath ,'/reference.bmp');
CLEAN = strcat(BatchPath ,'/clean.bmp');

% Read images
Noisy_Image     = imread(NOISY); 
Reference_Image = imread(REFERENCE);
Clean_Image     = imread(CLEAN);

% Metrics before
sprintf('Before denoising: MSE= %g, PSNR= %g, SSIM= %g',MSE(Reference_Image,Clean_Image,Noisy_Image),PSNR(Reference_Image,Clean_Image,Noisy_Image),SSIM(Reference_Image,Clean_Image,Noisy_Image))

% Sigma 5, 10, 15, 20, 25, 50
SIGMA = 25;

% Denoised_Image = BM3D(NOISY,SIGMA);
% Denoised_Image = KSVD_WRAP(NOISY,SIGMA);
% Denoised_Image = WNNM_WRAP(NOISY,SIGMA);
% Denoised_Image = FOE_WRAP(NOISY, SIGMA);
% Denoised_Image = NCSR_WRAP(NOISY,SIGMA);
% Denoised_Image = EPLL_WRAP(NOISY, SIGMA);

% Show images
figure; imshow(Noisy_Image);   
figure; imshow(Denoised_Image);

% Metrics after
sprintf('After denoising: MSE= %g, PSNR= %g, SSIM= %g',MSE(Reference_Image,Clean_Image,Denoised_Image),PSNR(Reference_Image,Clean_Image,Denoised_Image),SSIM(Reference_Image,Clean_Image,Denoised_Image))


