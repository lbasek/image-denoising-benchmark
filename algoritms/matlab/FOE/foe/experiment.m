%EXPERIMENT Simple demonstration of training and using a FoE model
%
% The function provides a simple demonstration of how to use a Field of
% Experts model as image prior for denoising and inpainting. The function
% also contains code to train a FoE model on a dataset of image patches. To
% execute this code, uncomment the training code in this function.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    clear all
    addpath('netlab');

    
% % Uncomment code below to perform FoE training using persistent CD
% % =======================================================================
%     disp('Training the Field of Experts model...');
% 
%     % Load data and convert to YCbCr
%     load 'image_patches.mat';
%     images = rgb2ycbcr(repmat(images, [1 1 3]) ./ 255);
%     images = images(:,:,1) .* 255;
%     patch_size = 5;
%     
%     % Construct dataset of image patches from the training data
%     image_size = sqrt(size(images, 2));
%     patches = zeros(size(images, 1) * ((image_size / patch_size) ^ 2), patch_size ^ 2);
%     count = 1;
%     for i=1:size(images, 1)
%         im = reshape(images(i,:), [image_size image_size]);
%         for x=1:patch_size:image_size
%             for y=1:patch_size:image_size
%                 tmp = im(y:y + patch_size - 1, x:x + patch_size - 1);
%                 patches(count,:) = tmp(1:end);
%                 count = count + 1;
%             end
%         end
%     end
%     
%     % Compute inverse whitening filter
%     [U, L] = eig(cov(patches));
%     basis = (L ^ -.5) * U';
%     basis(end,:) = [];                  % throws away basis corresponding to homogeneous image regions
%     clear patches im tmp count U L
%   
%     % Train Field of Experts model
%     if exist('W', 'var') && exist('a', 'var')
%         [W, a, train_err] = train_foe_pcd(images, basis, W, a);
%     else
%         [W, a, train_err] = train_foe_pcd(images, basis, 24);
%     end
%     save(['foe_' num2str(patch_size) 'x' num2str(patch_size) '.mat'], 'W', 'a', 'basis', 'train_err');
% % =======================================================================


    % Loads pretrained Field of Experts model
    patch_size = 5;
    load(['foe_' num2str(patch_size) 'x' num2str(patch_size) '.mat']);
    
    % Show filters
    disp('Show the Field of Experts filters...');
    figure(1);
    Wb = basis' * W;
    for i=1:size(Wb, 2)
        subplot(5, 5, i); 
        imagesc(reshape(Wb(:,i), [sqrt(size(Wb, 1)) sqrt(size(Wb, 1))]));
        colormap(gray);
        axis off;
    end
    
    % Perform denoising experiment
    disp('Performing denoising experiment...');
    figure(2);
    sigma = 20;
    im = double(imread('barbara.png')); 
    %im = double(imread('slika_04.BMP'));
    noisy_im = im + randn(size(im)) * sigma; %   ovo sam ja zakomentiral!
    %noisy_im = im;
    denoised_im = denoise_foe(noisy_im, basis, W, a, sigma);
    disp(['Signal-to-noise ratio of input : ' num2str(psnr(im, noisy_im))]);
    disp(['Signal-to-noise ratio of result: ' num2str(psnr(im, denoised_im))]);
    disp('Press a key to continue...'); pause
    
    % Perform inpainting experiment
    %{
    disp('Performing inpainting experiment...');
    figure(3);
    im = imread('street.png');
    mask = logical(imread('street_mask.png'));
    painted_im = inpaint_foe(im, mask, basis, W, a);
    %}
    