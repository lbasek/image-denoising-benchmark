function denoised_im = denoise_foe(im, basis, W, a, sigma)
%DENOISE_FOE Denoise image using Field of Experts prior model
%
%   denoised_im = denoise_foe(im, basis, W, a, sigma)
%
% Denoises the image im, using a Gaussian noise model with variance sigma, 
% and a Field of Experts image prior specified by basis, W, and a.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology

    
    % Initialize some variables
    eta = 10;
    max_iter = 275; %275 je bilo originalno
    im = double(im);
    dI = zeros(size(im));
    
    % Convert to YCbCr color space if input is RGB
    if size(im, 3) == 3
        im = 255 .* rgb2ycbcr(im ./ 255);
    end
    denoised_im = im;

    % Perform gradient iterations
    for iter=1:max_iter
        
        % Compute gradient of posterior log-likelihood
        for c=1:size(denoised_im, 3)
            dI(:,:,c) = reshape(foe_energy_grad_x(denoised_im(:,:,c), basis, W, a), [size(im, 1) size(im, 2)]);
        end
        dI = dI + (1 / sigma ^ 2) * (im - denoised_im);
        
        % Perform gradient update
        denoised_im = denoised_im - eta * dI;
        
        % Print progress
        if ~rem(iter, 10) || iter == max_iter
            
            % Compute energy of posterior
            E = foe_energy(denoised_im, basis, W, a, size(denoised_im)) + (1 ./ (sigma ^ 2)) * sum(((im(:) - denoised_im(:)) ./ 255) .^ 2);
            disp(['Iteration ' num2str(iter) ': energy is ' num2str(E)]);
                
            % Show intermediate result
            if size(im, 3) == 3
                tmp1 = uint8(round(255 .* ycbcr2rgb(im ./ 255)));
                tmp2 = uint8(round(255 .* ycbcr2rgb(denoised_im ./ 255)));
            else
                tmp1 = uint8(round(im));
                tmp2 = uint8(round(denoised_im));
            end
            subplot(1, 2, 1); imshow(tmp1); colormap(gray); title('Noisy image');
            subplot(1, 2, 2); imshow(tmp2); colormap(gray); title(['Denoised image (iteration ' num2str(iter) ')']);
            drawnow
        end
    end
    
    % Convert back to RGB if necessary
    if size(denoised_im, 3) == 3
        denoised_im = 255 .* ycbcr2rgb(denoised_im ./ 255);
    end 
    denoised_im = uint8(round(denoised_im));
    