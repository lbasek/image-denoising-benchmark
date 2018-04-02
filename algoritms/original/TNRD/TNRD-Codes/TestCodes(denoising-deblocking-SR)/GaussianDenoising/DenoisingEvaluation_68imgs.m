clear all; close all;
% clc;
%% load different model for different noise level
load JointTraining_7x7_400_180x180_stage=5_sigma=25.mat;
% load JointTraining_7x7_400_180x180_stage=5_sigma=15.mat;
% load JointTraining_7x7_400_180x180_stage=5_sigma=5.mat;

filter_size = 7;
m = filter_size^2 - 1;
filter_num = 48;
BASIS = gen_dct2(filter_size);
BASIS = BASIS(:,2:end);
%% pad and crop operation
bsz = filter_size+1;
bndry = [bsz,bsz];
pad   = @(x) padarray(x,bndry,'symmetric','both');
crop  = @(x) x(1+bndry(1):end-bndry(1),1+bndry(2):end-bndry(2));
%% MFs means and precisions
KernelPara.fsz = filter_size;
KernelPara.filtN = filter_num;
KernelPara.basis = BASIS;
trained_model = save_trained_model(cof, MFS, stage, KernelPara);
%% test 68 images
img_num = 68;
sigma = 25;
psnr = zeros(img_num,1);
reset(RandStream.getDefaultStream);
for img_idx = 1:img_num
    path = './68imgs/';
    file = strcat(path,sprintf('test%03d.png', img_idx));
    I0 = double(imread(file));
    Im = I0 + sigma*randn(size(I0));
    [R,C] = size(I0);
    rms1 = sqrt(mean((Im(:) - I0(:)).^2)) /sigma * 25;
    %% run denoising, 5 stages
    input = pad(Im);
    noisy = pad(Im);
    clean = I0;
    for s = 1:stage
        deImg = denoisingOneStepGMixMFs(noisy, input, trained_model{s});
        t = crop(deImg);
        deImg = pad(t);
        input = deImg;

        rms = sqrt(mean((t(:) - clean(:)).^2));
        fprintf('stage = %d, psnr = %f\n',s, 20*log10(255/rms));
    end
    x_star = max(0, min(t(:), 255));
    %% recover image
    rms2 = sqrt(mean((x_star - I0(:)).^2));
    PSNR = 20*log10(255/rms2);
    recover = reshape(x_star,R,C);
    fprintf('Denoising image %3d\tPSNR: %.3f\n',img_idx,PSNR);
    %% show images
    % figure(img_idx);
    % subplot(1,3,1);imshow(I0,[0 255]);title('original image');
    % subplot(1,3,2);imshow(Im,[0 255]);title('noisy image');
    % subplot(1,3,3);imshow(recover,[0 255]);
    % str = strcat('denoised image,',sprintf('PSNR:%.3f', PSNR));
    % title(str);
    % drawnow;
    psnr(img_idx) = PSNR;
    % path = './7x7_stage=5/';
    % file = strcat(path,sprintf('test%03d_TRD7x7_5.png', img_idx));
    % imwrite(recover/255,file);
end
mean(psnr)