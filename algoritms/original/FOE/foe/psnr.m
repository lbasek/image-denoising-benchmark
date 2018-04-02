function snr = psnr(x, y)
%PSNR Computes peak signal-to-noise ratio of two signals x and y
%
%   snr = psnr(x, y)
%
% Computes peak signal-to-noise ratio of signals y, given that the true 
% signal is x.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology

    
    % Compute the PSNR
    x = double(x); 
    y = double(y);
    snr = 20 * log10(255 / std(x(:) - y(:)));

