function denoised = NCSR_WRAP(image_path, sigma)

    Noisy_Image = imread(image_path); 
    par     =   Parameters_setting( sigma );
    par.nim =   double( Noisy_Image );
    
    denoised = uint8(255 * mat2gray(NCSR_Denoising( par )));
     
end



