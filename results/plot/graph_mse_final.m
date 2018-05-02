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

mse_row_10 = T_10(1,:);
mse_row_15 = T_15(1,:);
mse_row_20 = T_20(1,:);
mse_row_25 = T_25(1,:);
mse_row_50 = T_50(1,:);


x = [0,10,15,20,25,50];

bm3d_10 = mse_row_10{1,3};
bm3d_15 = mse_row_15{1,3};
bm3d_20 = mse_row_20{1,3};
bm3d_25 = mse_row_25{1,3};
bm3d_50 = mse_row_50{1,3};

ksvd_10 = mse_row_10{1,4};
ksvd_15 = mse_row_15{1,4};
ksvd_20 = mse_row_20{1,4};
ksvd_25 = mse_row_25{1,4};
ksvd_50 = mse_row_50{1,4};

foe_10 = mse_row_10{1,5};
foe_15 = mse_row_15{1,5};
foe_20 = mse_row_20{1,5};
foe_25 = mse_row_25{1,5};
foe_50 = mse_row_50{1,5};

epll_10 = mse_row_10{1,6};
epll_15 = mse_row_15{1,6};
epll_20 = mse_row_20{1,6};
epll_25 = mse_row_25{1,6};
epll_50 = mse_row_50{1,6};



y1 = [mse_row_10{1,2}, bm3d_10,bm3d_15,bm3d_20,bm3d_25,bm3d_50];
y2 = [mse_row_10{1,2}, ksvd_10,ksvd_15,ksvd_20,ksvd_25,ksvd_50];
y3 = [mse_row_10{1,2}, foe_10,foe_15,foe_20,foe_25,foe_50];
y4 = [mse_row_10{1,2}, epll_10,epll_15,epll_20,epll_25,epll_50];


h = figure;
hold on
h1 = plot(x,y1,'-s','MarkerSize',10);
h2 = plot(x,y2,'-s','MarkerSize',10);
h3 = plot(x,y3,'-s','MarkerSize',10);
h4 = plot(x,y4,'-s','MarkerSize',10);
hold off
set([h1,h2,h3,h4],'LineWidth',2)
ylabel('MSE')
xlabel('Noise Power')
legend('BM3D','KSVD','FOE','EPLL');
grid on
saveas(h,'./graphs/mse','png');

