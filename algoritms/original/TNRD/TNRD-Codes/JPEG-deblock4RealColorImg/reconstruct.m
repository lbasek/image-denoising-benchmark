function u = reconstruct(JPEG_header_info)
bs = 8;
offset = 128;
T = dctmtx(bs);
invdct = @(block_struct) T' * block_struct.data * T;
%% y channel
Q = JPEG_header_info.quant_tables{1};
cofQ = JPEG_header_info.coef_arrays{1};
multiply = @(block_struct) block_struct.data.*Q;
cof = blockproc(cofQ,[bs bs],multiply);    
y = blockproc(cof,[bs bs],invdct);

y = y + offset;
y = min(max(y,0),255);
y = y/255*219 + 16;
% return;
% y = max(-128, min(y, 127)) + offset;

%% cb channel
Q = JPEG_header_info.quant_tables{2};
cofQ = JPEG_header_info.coef_arrays{2};
multiply = @(block_struct) block_struct.data.*Q;
cof = blockproc(cofQ,[bs bs],multiply);    
cb = blockproc(cof,[bs bs],invdct);

cb = cb + offset;
cb = min(max(cb,0),255);
cb = cb/255*224 + 16;

%% cr channel
Q = JPEG_header_info.quant_tables{2};
cofQ = JPEG_header_info.coef_arrays{3};
multiply = @(block_struct) block_struct.data.*Q;
cof = blockproc(cofQ,[bs bs],multiply);
cr = blockproc(cof,[bs bs],invdct);

cr = cr + offset;
cr = min(max(cr,0),255);
cr = cr/255*224 + 16;

cb = cb(1:JPEG_header_info.image_height/2, 1:JPEG_header_info.image_width/2);
cr = cr(1:JPEG_header_info.image_height/2, 1:JPEG_header_info.image_width/2);
[ny,my] = size(y);
%Upscale color components
cb = imresize(cb,[ny,my]);
cr = imresize(cr,[ny,my]);
%Retransform image
u = cat(3,y,cb,cr);
% u = u + offset;
u = uint8(u);
u = ycbcr2rgb(u);