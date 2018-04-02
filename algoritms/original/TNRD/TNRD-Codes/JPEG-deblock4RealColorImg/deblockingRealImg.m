clear variables; close all;
bs = 8;
offset = 128;

T = dctmtx(bs);
invdct = @(block_struct) T' * block_struct.data * T;
dct = @(block_struct) T * block_struct.data * T';
bsz = 5;
bndry = [bsz,bsz];
pad   = @(x) padarray(x,bndry,'symmetric','both');
crop  = @(x) x(1+bndry(1):end-bndry(1),1+bndry(2):end-bndry(2));

load JointTraining_7x7_400_176X176_stage=4_Q=30.mat;
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
filename = '.\web-imgs\baker-beach-compressed.jpg';

JPEG_header_info = jpeg_read(filename);
JPEG_header_info.quant_tables{3} = JPEG_header_info.quant_tables{2};
scale_h = JPEG_header_info.comp_info(1).h_samp_factor;
scale_v = JPEG_header_info.comp_info(1).v_samp_factor;
[M, N] = size(JPEG_header_info.coef_arrays{1});
% [Ms, Ns] = size(JPEG_header_info.coef_arrays(2));

recover = zeros(JPEG_header_info.image_height, JPEG_header_info.image_width, 3);
num = 3;
for idx = 1:num
    cofQ = JPEG_header_info.coef_arrays{idx};
    Q = JPEG_header_info.quant_tables{idx};
    
    factor = 1;
    minus = @(block_struct) block_struct.data.*Q - 0.5*Q*factor;
    plus = @(block_struct) block_struct.data.*Q + 0.5*Q*factor;
    multiply = @(block_struct) block_struct.data.*Q;
        
    lcof = blockproc(cofQ,[bs bs],minus);
    ucof = blockproc(cofQ,[bs bs],plus);
    
    cof = blockproc(cofQ,[bs bs],multiply);
    center = blockproc(cof,[bs bs],invdct);
    center = max(-128, min(center, 127));
    sfigure(1);imshow(center+offset, [0 255]);drawnow;
    %% run denoising, x stages
    input = center;
    run_stage = 4;
    for s = 1:run_stage
        deImg = deblocking_one_step(input, ucof, lcof, trained_model{s}, pad, crop);
        input = deImg;
        
        fprintf('stage = %d\n',s);
    end
    sfigure(2);imshow(deImg+offset, [0 255]);
    if idx > 1
        [tr, tc] = size(deImg);
        deImg = imresize(deImg, [tr*scale_v, tc*scale_h]);
    end
    deImg = deImg(1:JPEG_header_info.image_height, 1:JPEG_header_info.image_width);
    recover(:,:,idx) = deImg;
end
% Retransform image
recover(:,:,1) = (recover(:,:,1) + offset)/255*219 + 16;
recover(:,:,2) = (recover(:,:,2) + offset)/255*224 + 16;
recover(:,:,3) = (recover(:,:,3) + offset)/255*224 + 16;
u = recover;
u = uint8(u);
u = ycbcr2rgb(u);
sfigure(3);imshow(u);

filename(end-2:end) = 'png';
imwrite(u, filename);
