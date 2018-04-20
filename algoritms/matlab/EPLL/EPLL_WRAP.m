function denoised = EPLL_WRAP(image_path, sigma)

    Noisy_Image = double(imread(image_path))/255;	

    redChannel = Noisy_Image(:,:,1); % Red channel
    greenChannel = Noisy_Image(:,:,2); % Green channel
    blueChannel = Noisy_Image(:,:,3); % Blue channel
    
%     redChannel=im2double(redChannel);
%     if (length(size(redChannel))>2)
%         redChannel = rgb2gray(redChannel);
%     end
%     if (max(redChannel(:))<2)
%         redChannel = redChannel*255;
%     end
% 
%     greenChannel=im2double(greenChannel);
%     if (length(size(greenChannel))>2)
%         greenChannel = rgb2gray(greenChannel);
%     end
%     if (max(greenChannel(:))<2)
%         greenChannel = greenChannel*255;
%     end
% 
%     blueChannel=im2double(blueChannel);
%     if (length(size(blueChannel))>2)
%         blueChannel = rgb2gray(blueChannel);
%     end
%     if (max(blueChannel(:))<2)
%         blueChannel = blueChannel*255;
%     end

    patchSize = 8;
    excludeList = [];

    % set up prior
    LogLFunc = [];
    load GSModel_8x8_200_2M_noDC_zeromean.mat
    prior = @(Z,patchSize,sigma,imsize) aprxMAPGMM(Z,patchSize,sigma,imsize,GS,excludeList);

    [Denoised_Image_Red,~,~] = EPLLhalfQuadraticSplit(redChannel,patchSize^2/sigma^2,patchSize,(1/sigma^2)*[1 4 8 16 32],1,prior,redChannel,LogLFunc);
    [Denoised_Image_Green,~,~] = EPLLhalfQuadraticSplit(greenChannel,patchSize^2/sigma^2,patchSize,(1/sigma^2)*[1 4 8 16 32],1,prior,greenChannel,LogLFunc);
    [Denoised_Image_Blue,~,~] = EPLLhalfQuadraticSplit(blueChannel,patchSize^2/sigma^2,patchSize,(1/sigma^2)*[1 4 8 16 32],1,prior,blueChannel,LogLFunc);

    recombinedRGBImage = cat(3, Denoised_Image_Red, Denoised_Image_Green, Denoised_Image_Blue);
    
    denoised = uint8(255 * mat2gray(recombinedRGBImage));
   
end



