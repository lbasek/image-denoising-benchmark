function [denoised_im] = FOE_WRAP( imagePath, sigmaValue )
% foe_nos_projekt('../../../../dataset/batch1/noisy.bmp', 20)

% Loads pretrained Field of Experts model
patch_size = 5;
load(['foe_' num2str(patch_size) 'x' num2str(patch_size) '.mat']);

% Perform denoising experiment
%disp('Performing denoising experiment...');
%figure(2);
im = double(imread(imagePath));
%noisy_im = im + randn(size(im)) * sigmaValue; % ako saljes sliku koja vec ima šum onda ovo ne treba.
noisy_im = im;
denoised_im = denoise_foe(noisy_im, basis, W, a, sigmaValue);
%disp(['Signal-to-noise ratio of input : ' num2str(psnr(im, noisy_im))]);
%disp(['Signal-to-noise ratio of result: ' num2str(psnr(im, denoised_im))]);
%disp('Press a key to continue...'); pause

end
