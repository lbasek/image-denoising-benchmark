function denoised = WNNM_WRAP(image_path, sigma)

    Noisy_Image = im2double(imread(image_path));

    redChannel = Noisy_Image(:,:,1); % Red channel
    greenChannel = Noisy_Image(:,:,2); % Green channel
    blueChannel = Noisy_Image(:,:,3); % Blue channel
    
    redChannel=im2double(redChannel);
    if (length(size(redChannel))>2)
        redChannel = rgb2gray(redChannel);
    end
    if (max(redChannel(:))<2)
        redChannel = redChannel*255;
    end

    greenChannel=im2double(greenChannel);
    if (length(size(greenChannel))>2)
        greenChannel = rgb2gray(greenChannel);
    end
    if (max(greenChannel(:))<2)
        greenChannel = greenChannel*255;
    end

    blueChannel=im2double(blueChannel);
    if (length(size(blueChannel))>2)
        blueChannel = rgb2gray(blueChannel);
    end
    if (max(blueChannel(:))<2)
        blueChannel = blueChannel*255;
    end

    Par   = ParSet(sigma);   
    Denoised_Image_Red = WNNM_DeNoising( redChannel, Par );  
    Denoised_Image_Green = WNNM_DeNoising( greenChannel, Par );  
    Denoised_Image_Blue = WNNM_DeNoising( blueChannel, Par );

    recombinedRGBImage = cat(3, Denoised_Image_Red, Denoised_Image_Green, Denoised_Image_Blue);
    
    denoised = uint8(255 * mat2gray(recombinedRGBImage));
   
end



