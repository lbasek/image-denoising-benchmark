clear variables; close all;
q = 10;
bs = 8;
offset = 128;

%% read images
% folder_test = 'D:\MatlabCodes\AR-CNN\code\LIVE1';
folder_test = 'D:\MatlabCodes\JPEGdeblocking\DeblockingTestDataSet\quality10\labels';
ext         =  {'*.jpg','*.png','*.bmp'};
filepaths =  [];
for i = 1 : length(ext)
    filepaths = [filepaths; dir(fullfile(folder_test, ext{i}))];
end

T = dctmtx(bs);
invdct = @(block_struct) T' * block_struct.data * T;
dct = @(block_struct) T * block_struct.data * T';
bsz = 5;
bndry = [bsz,bsz];
pad   = @(x) padarray(x,bndry,'symmetric','both');
crop  = @(x) x(1+bndry(1):end-bndry(1),1+bndry(2):end-bndry(2));

load JointTraining_7x7_400_176X176_stage=4.mat;
% load JointTraining_7x7_400_176X176_stage=4_Q=20.mat;
% load JointTraining_7x7_400_176X176_stage=4_Q=30.mat;

filter_size = 7;
m = filter_size^2 - 1;
filter_num = 48;
BASIS = gen_dct2(filter_size);
BASIS = BASIS(:,2:end);
%% MFs means and precisions
KernelPara.fsz = filter_size;
KernelPara.filtN = filter_num;
KernelPara.basis = BASIS;
%% MFs means and precisions
check_stage = 4;
trained_model = save_trained_model(cof, MFS, check_stage, KernelPara);

num = length(filepaths);
PSNR = zeros(num,1);
PSNR_in = zeros(num,1);
PSNR_B = zeros(num,1);
for idx = 1:num
    im = imread(fullfile(folder_test,filepaths(idx).name));
    %% work on illuminance only
    if size(im,3)>1
        im = rgb2ycbcr(im);
        im = im(:, :, 1);
    end
    
    imwrite(im,'test.jpg','jpg','Quality',q);
    im = double(im);
    JPEG_header_info = jpeg_read('test.jpg');
    Q = JPEG_header_info.quant_tables{1};
    cofQ = JPEG_header_info.coef_arrays{1};
    
    factor = 0.8;
    minus = @(block_struct) block_struct.data.*Q - 0.5*Q*factor;
    plus = @(block_struct) block_struct.data.*Q + 0.5*Q*factor;
    multiply = @(block_struct) block_struct.data.*Q;
  
    lcof = blockproc(cofQ,[bs bs],minus);
    ucof = blockproc(cofQ,[bs bs],plus);
    
    cof = blockproc(cofQ,[bs bs],multiply);
    center = blockproc(cof,[bs bs],invdct);
    center = max(-128, min(center, 127));
    
    res = center(1:JPEG_header_info.image_height, 1:JPEG_header_info.image_width);
    rms = sqrt(mean((res(:)+offset - im(:)).^2));
    fprintf('input image, psnr = %f\n',20*log10(255/rms));
    PSNR_in(idx) = 20*log10(255/rms);
    %% run denoising, x stages
    input = center;
    run_stage = 4;    
    for s = 1:run_stage
        deImg = deblocking_one_image(input, ucof, lcof, trained_model{s}, pad, crop);
        input = deImg;
        
        res = deImg(1:JPEG_header_info.image_height, 1:JPEG_header_info.image_width);
        rms = sqrt(mean((res(:)+offset - im(:)).^2));
        fprintf('stage = %d, psnr = %f\n',s, 20*log10(255/rms));
    end
    
    psnr = 20*log10(255/rms);
    fprintf('Denoising image %3d\tPSNR: %.3f\n',idx,psnr);
    PSNR(idx) = psnr;
    PSNR_B(idx) = compute_psnrb(res+offset, im);
    
    imwrite((res+offset)/255,['./recovery_joint/q=10/' filepaths(idx).name]);
%     sfigure(idx);
%     subplot(1,3,1);imshow(clean, [0 255]);title('original image');
%     subplot(1,3,2);imshow(center+offset, [0 255]);title('compressed image');
%     subplot(1,3,3);imshow(t+offset, [0 255]);title(['recovered image, psnr: ',sprintf('%.2f',psnr)]);
%     drawnow;
end
mean(PSNR)
% save('./recovery_joint/q=10/psnr_s08.mat','PSNR');