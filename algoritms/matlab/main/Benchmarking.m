addpath(genpath('../BM3D'));
addpath(genpath('../FOE'));
addpath(genpath('../KSVD'));
addpath(genpath('../NCSR'));
addpath(genpath('../FOE'));
addpath(genpath('../WNNM'));
addpath(genpath('../PSNR'));
addpath(genpath('../MSE'));
addpath(genpath('../SSIM'));

BM3D = 1;
KSVD = 1;
WNNM = 0;
FOE  = 0;
NCSR = 0;
EPLL = 0;


% SIGMA [ 10, 15, 20, 25, 50 ]
SIGMA =[10];

% time TODO

for s = SIGMA
    
    original_mse  = [];
    original_psnr = [];
    original_ssim = [];
    
    bm3d_mse   = [];
    bm3d_psnr  = [];
    bm3d_ssim  = [];
    
    ksvd_mse   = [];
    ksvd_psnr  = [];
    ksvd_ssim  = [];
    
    %images
    for i = 1:2
        
        BatchPath = strcat('../../../dataset/batch',int2str(i));

        NOISY = strcat(BatchPath ,'/noisy.bmp');
        REFERENCE = strcat(BatchPath ,'/reference.bmp');
        CLEAN = strcat(BatchPath ,'/clean.bmp');

        % Read images
        Noisy_Image     = imread(NOISY); 
        Reference_Image = imread(REFERENCE);
        Clean_Image     = imread(CLEAN);
             
        % Init table
        tableResults = table();
        
        % Evaluation before denoising
        mse  =  MSE(Reference_Image,Clean_Image,Noisy_Image);
        psnr =  PSNR(Reference_Image,Clean_Image,Noisy_Image);
        ssim =  SSIM(Reference_Image,Clean_Image,Noisy_Image);
        sprintf('Before denoising: MSE= %g, PSNR= %g, SSIM= %g',mse, psnr, ssim);
        
        original_mse = [original_mse mse];
        original_psnr = [original_psnr psnr];
        original_ssim = [original_ssim ssim];

        row = cell2table({'before-denoising',mse,psnr,ssim});
        tableResults = [tableResults ; row];

        %--------------------------------------------------------------------------------------------------------
        
        % BM3D
        if BM3D == 1
            Denoised_Image_BM3D = BM3D(NOISY,s);
            mse  =  MSE(Reference_Image,Clean_Image,Denoised_Image_BM3D);
            psnr =  PSNR(Reference_Image,Clean_Image,Denoised_Image_BM3D);
            ssim =  SSIM(Reference_Image,Clean_Image,Denoised_Image_BM3D);
            sprintf('After BM3D denoising: MSE= %g, PSNR= %g, SSIM= %g',mse, psnr, ssim);

            bm3d_mse = [bm3d_mse mse];
            bm3d_psnr = [bm3d_psnr psnr];
            bm3d_ssim = [bm3d_ssim ssim];

            row = cell2table({'BM3D',mse,psnr,ssim});
            tableResults = [tableResults ; row];
        end

        %--------------------------------------------------------------------------------------------------------

        % KSVD
        if KSVD == 1
            Denoised_Image_KSVD = KSVD_WRAP(NOISY,s);
            mse  =   MSE(Reference_Image,Clean_Image,Denoised_Image_KSVD);
            psnr =  PSNR(Reference_Image,Clean_Image,Denoised_Image_KSVD);
            ssim =  SSIM(Reference_Image,Clean_Image,Denoised_Image_KSVD);
            sprintf('After KSVD denoising: MSE= %g, PSNR= %g, SSIM= %g',mse, psnr, ssim);
            
            ksvd_mse  = [ksvd_mse mse];
            ksvd_psnr = [ksvd_psnr psnr];
            ksvd_ssim = [ksvd_ssim ssim];

            row = cell2table({'KSVD',mse,psnr,ssim});
            tableResults = [tableResults ; row];
        end
        %--------------------------------------------------------------------------------------------------------

        % WNNM
        if WNNM == 1
            Denoised_Image_WNNM = WNNM_WRAP(NOISY,s);
            mse  =   MSE(Reference_Image,Clean_Image,Denoised_Image_WNNM);
            psnr =  PSNR(Reference_Image,Clean_Image,Denoised_Image_WNNM);
            ssim =  SSIM(Reference_Image,Clean_Image,Denoised_Image_WNNM);
            sprintf('After WNNM denoising: MSE= %g, PSNR= %g, SSIM= %g',mse, psnr, ssim);

            row = cell2table({'WNNM',mse,psnr,ssim});
            tableResults = [tableResults ; row];
        end
        %--------------------------------------------------------------------------------------------------------

        % FOE
        if FOE == 1
            Denoised_Image_FOE = FOE_WRAP(NOISY, s);
            mse  =   MSE(Reference_Image,Clean_Image,Denoised_Image_FOE);
            psnr =  PSNR(Reference_Image,Clean_Image,Denoised_Image_FOE);
            ssim =  SSIM(Reference_Image,Clean_Image,Denoised_Image_FOE);
            sprintf('After FOE denoising: MSE= %g, PSNR= %g, SSIM= %g',mse, psnr, ssim);

            row = cell2table({'FOE',mse,psnr,ssim});
            tableResults = [tableResults ; row];
        end

        %--------------------------------------------------------------------------------------------------------

        % NCSR
        if NCSR == 1
            Denoised_Image_NCSR = NCSR_WRAP(NOISY,s);
            mse  =   MSE(Reference_Image,Clean_Image,Denoised_Image_NCSR);
            psnr =  PSNR(Reference_Image,Clean_Image,Denoised_Image_NCSR);
            ssim =  SSIM(Reference_Image,Clean_Image,Denoised_Image_NCSR);
            sprintf('After NCSR denoising: MSE= %g, PSNR= %g, SSIM= %g',mse, psnr, ssim);

            row = cell2table({'NCSR',mse,psnr,ssim});
            tableResults = [tableResults ; row];
        end
        
        %--------------------------------------------------------------------------------------------------------

               
        % EPLL
        if EPLL == 1
            Denoised_Image_EPLL = EPLL_WRAP(NOISY, s);
            mse  =   MSE(Reference_Image,Clean_Image,Denoised_Image_EPLL);
            psnr =  PSNR(Reference_Image,Clean_Image,Denoised_Image_EPLL);
            ssim =  SSIM(Reference_Image,Clean_Image,Denoised_Image_EPLL);
            sprintf('After EPLL denoising: MSE= %g, PSNR= %g, SSIM= %g',mse, psnr, ssim);

            row = cell2table({'EPLL',mse,psnr,ssim});
            tableResults = [tableResults ; row];
        end

        %--------------------------------------------------------------------------------------------------------

        filename = strcat('results_sigma',int2str(s),'_image', int2str(i),'.txt');
        tableResults.Properties.VariableNames = {'Algorithm' 'MSE' 'PSNR' 'SSIM'};
        writetable(tableResults,filename, 'Delimiter',',')
        type filename
    
    end
    
    finalResults = table();
    finalResults.Properties.VariableNames = {'QUALITY-METRIC' 'ORIGINAL' 'BM3D' 'KSVD' 'WNNM' 'FOE' 'NCSR' 'EPLL'};
    row = cell2table({'PSNR',mean(original_psnr),mean(bm3d_psnr),0,0,0,0,0});
    finalResults = [finalResults ; row];
    
    filename = strcat('final_results_',int2str(s),'.txt');
    writetable(finalResults,filename, 'Delimiter',',')
    type filename

end   

% Show images
% figure; imshow(Noisy_Image);   
% figure; imshow(Denoised_Image);



