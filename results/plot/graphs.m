T_10 = readtable('/Users/lbasek/image-denoising-benchmark/results/final_results_sigma10.csv');
T_10(:,'WNNM') = [];
T_10(:,'NCSR') = [];

T_15 = readtable('/Users/lbasek/image-denoising-benchmark/results/final_results_sigma15.csv');
T_15(:,'WNNM') = [];
T_15(:,'NCSR') = [];

T_20 = readtable('/Users/lbasek/image-denoising-benchmark/results/final_results_sigma20.csv');
T_20(:,'WNNM') = [];
T_20(:,'NCSR') = [];

T_25 = readtable('/Users/lbasek/image-denoising-benchmark/results/final_results_sigma25.csv');
T_25(:,'WNNM') = [];
T_25(:,'NCSR') = [];

T_50 = readtable('/Users/lbasek/image-denoising-benchmark/results/final_results_sigma50.csv');
T_50(:,'WNNM') = [];
T_50(:,'NCSR') = [];

psnr_row_10 = T_10(2,:);
psnr_row_15 = T_15(2,:);
psnr_row_20 = T_20(2,:);
psnr_row_25 = T_25(2,:);
psnr_row_50 = T_50(2,:);


x = [0,10,15,20,25,50];

bm3d_10 = psnr_row_10{1,3};
bm3d_15 = psnr_row_15{1,3};
bm3d_20 = psnr_row_20{1,3};
bm3d_25 = psnr_row_25{1,3};
bm3d_50 = psnr_row_50{1,3};

ksvd_10 = psnr_row_10{1,4};
ksvd_15 = psnr_row_15{1,4};
ksvd_20 = psnr_row_20{1,4};
ksvd_25 = psnr_row_25{1,4};
ksvd_50 = psnr_row_50{1,4};

foe_10 = psnr_row_10{1,5};
foe_15 = psnr_row_15{1,5};
foe_20 = psnr_row_20{1,5};
foe_25 = psnr_row_25{1,5};
foe_50 = psnr_row_50{1,5};

epll_10 = psnr_row_10{1,6};
epll_15 = psnr_row_15{1,6};
epll_20 = psnr_row_20{1,6};
epll_25 = psnr_row_25{1,6};
epll_50 = psnr_row_50{1,6};



y1 = [psnr_row_10{1,2}, bm3d_10,bm3d_15,bm3d_20,bm3d_25,bm3d_50];
y2 = [psnr_row_10{1,2}, ksvd_10,ksvd_15,ksvd_20,ksvd_25,ksvd_50];
y3 = [psnr_row_10{1,2}, foe_10,foe_15,foe_20,foe_25,foe_50];
y4 = [psnr_row_10{1,2}, epll_10,epll_15,epll_20,epll_25,epll_50];



hold on
h1 = plot(x,y1,'-s','MarkerSize',10);
h2 = plot(x,y2,'-s','MarkerSize',10);
h3 = plot(x,y3,'-s','MarkerSize',10);
h4 = plot(x,y4,'-s','MarkerSize',10);
hold off
set([h1,h2,h3,h4],'LineWidth',2)
ylabel('PSNR(dB)')
xlabel('Noise Power')
legend('BM3D','KSVD','FOE','EPLL');
grid on

