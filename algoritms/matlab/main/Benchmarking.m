addpath(genpath('../BM3D'));
addpath(genpath('../FOE'));
addpath(genpath('../KSVD'));
addpath(genpath('../NCSR'));
addpath(genpath('../FOE'));
addpath(genpath('../WNNM'));
addpath(genpath('../PSNR'));

NOISY = '/noisy.bmp';
REFERENCE = '/reference.bmp';
CLEAN = '/clean.bmp';

BatchPath = '../../../dataset/batch2';

% Read images
Noisy_Image = imread(strcat(BatchPath , NOISY)); 
Reference_Image = imread(strcat(BatchPath ,REFERENCE));
Clean_Image = imread(strcat(BatchPath , CLEAN));

% PSNR before
value = SigmaNoisy(double(Reference_Image),double(Noisy_Image),double(Clean_Image));
PSNR = 20*log10(255/value(:,4));
sprintf('The PSNR value is %g.', PSNR)

% Sigma 5, 10, 15, 20, 25, 50

% Denoised_Image = BM3D(strcat(BatchPath , NOISY),25);
% Denoised_Image = KSVD_WRAP(strcat(BatchPath , NOISY),10);
% Denoised_Image = WNNM_WRAP(strcat(BatchPath , NOISY),10);
% Denoised_Image = FOE_WRAP(strcat(BatchPath , NOISY), 10);
% Denoised_Image = NCSR_WRAP(strcat(BatchPath , NOISY),25);
% Denoised_Image = EPLL_WRAP(strcat(BatchPath , NOISY), 10);

% Show images
figure; imshow(Noisy_Image);   
figure; imshow(Denoised_Image);

% PSNR after
value = SigmaNoisy(double(Reference_Image),double(Denoised_Image),double(Clean_Image));
PSNR = 20*log10(255/value(:,4));
sprintf('The PSNR value after denoising is %g.', PSNR)


