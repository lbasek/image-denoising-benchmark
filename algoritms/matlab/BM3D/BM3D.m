function [noisy, denoised] = BM3D(image_path, sigma)
    yRGB = im2double(imread(image_path));
    zRGB = yRGB + (sigma/255)*randn(size(yRGB));
    [~, yRGB_est] = CBM3D(1, zRGB, sigma); 
    
    noisy = yRGB;
    denoised = uint8(255 * mat2gray(yRGB_est));
end