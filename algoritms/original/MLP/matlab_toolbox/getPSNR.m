%   Author: Harold Christopher Burger
%   Date:   March 19, 2012.

function PSNR = getPSNR(noisy, clean, maxVal)

	%N = noisy;
	%N(find(N>maxVal)) = maxVal;
	%N(find(N<0)) = 0;

	%noisy(noisy<0) = 0;
	%noisy(noisy>maxVal) = maxVal;

	Diff = noisy - clean;
	%Diff = Diff(dx+1:end-dx, dx:1:end-dx);
	RMSE = sqrt(mean(Diff(:).^2));
	%RMSE = std(Diff(:));
	PSNR = 20*log10(maxVal/RMSE);

	%clear N; clear Diff;
	clear Diff;

end

