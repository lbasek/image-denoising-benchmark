  
tic
    nSig  = 20;
    O_Img = double(rgb2gray(imread('../lbasek/Downloads/WNNM/clean.bmp')));
    N_Img = double(rgb2gray(imread('../lbasek/Downloads/WNNM/noisy.bmp')));
     
   
    Par   = ParSet(nSig);   
    E_Img = WNNM_DeNoising(N_Img, Par);
    PSNR  = csnr( O_Img, E_Img, 0, 0 );
    toc

    fprintf( 'Estimated Image: nSig = %2.3f, PSNR = %2.2f \n\n\n', nSig, PSNR );
    imshow(uint8(E_Img));