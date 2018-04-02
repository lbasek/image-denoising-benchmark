clear all; 
close all;
% clc;
% load JointTraining_91imgs_7x7_stage=5_s=2-G-Bicubic.mat;
load JointTraining_91imgs_7x7_stage=5_s=3-G-Bicubic.mat;
% load JointTraining_91imgs_7x7_stage=5_s=4-G-Bicubic.mat;

filter_size = 7;
m = filter_size^2 - 1;
filter_num = 48;
BASIS = gen_dct2(filter_size);
BASIS = BASIS(:,2:end);
%% pad and crop operation
up_scale = 3;
bsz = 6;
if up_scale == 4
    bsz = 8;
end
bndry = [bsz,bsz];
pad   = @(x) padarray(x,bndry,'symmetric','both');
crop  = @(x) x(1+bndry(1):end-bndry(1),1+bndry(2):end-bndry(2));
padLR = @(x) padarray(x,bndry/up_scale,'symmetric','both');
%% MFs means and precisions
KernelPara.fsz = filter_size;
KernelPara.filtN = filter_num;
KernelPara.basis = BASIS;
%% MFs means and precisions
trained_model = save_trained_model(cof, MFS, stage, KernelPara);
img_names = {'baboon', 'barbara', 'bridge', 'coastguard', 'comic', 'face', 'flowers', 'foreman', ...
    'lenna', 'man', 'monarch', 'pepper', 'ppt3', 'zebra'};
% img_names = {'baby', 'bird', 'butterfly', 'head', 'woman'};
n_imgs = length(img_names);
psnr = zeros(n_imgs,1);
for idx = 1:n_imgs
    file = ['Set14/', img_names{idx}, '.bmp'];
%     file = ['Set5/', img_names{idx}, '_GT.bmp'];
    im = imread(file);
    %% work on illuminance only
    if size(im,3)>1
        im = rgb2ycbcr(im);
        im = im(:, :, 1);
    end
    im_gnd = modcrop(im, up_scale);
    im_gnd = double(im_gnd);
    %% bicubic interpolation
    im_l = imresize(im_gnd, 1/up_scale, 'bicubic');
    im_b = imresize(im_l, up_scale, 'bicubic');

    input = pad(im_b);
    noisy = padLR(im_l);
    im_gnd = shave(uint8(im_gnd), [up_scale, up_scale]);
    im_b = shave(uint8(im_b), [up_scale, up_scale]);
    psnr_bic = compute_psnr(im_gnd,im_b);
    
    %% run denoising, s stages
    run_stage = 5;
    tic;
    for s = 1:run_stage
        deImg = SROneStepGMixMFs(noisy, input, trained_model{s}, up_scale);
        t = crop(deImg);
        deImg = pad(t);
        input = deImg;

        %% Evaluation PSNR
        im_h = shave(uint8(t), [up_scale, up_scale]);
        psnr_trd = compute_psnr(im_gnd,im_h);
    %     rms = sqrt(mean((t(:) - clean(:)).^2));
        fprintf('stage = %d, BI = %.4f, psnr = %f\n',s, psnr_bic, psnr_trd);
    end
    toc
    psnr(idx) = psnr_trd;
end
mean(psnr)
%% show images
% figure;
% % subplot(1,3,1);imshow(im_gnd);title('original image');
% % subplot(1,3,2);imshow(im_b);title('BI image');
% imshow(im_h);
% str = strcat('TRD-SR image,',sprintf('PSNR:%.3f', psnr_trd));
% title(str);
% drawnow;