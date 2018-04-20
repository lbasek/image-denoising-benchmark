function painted_im = inpaint_foe(im, mask, basis, W, a)
%INPAINT_FOE Perform inpainting on image using Field of Experts prior
%
%   painted_im = inpaint_foe(im, mask, basis, W, a)
%
% Performs inpainting on image im using the specified mask (the image is
% inpainted wherever mask is true). The inpainting is performed based on
% a Field of Experts prior that is defined by W and a.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Initialize some variables
    mask = logical(mask);
    im = double(im);
    max_iter = 2500;
    eta = 3000;
    
    % Convert to YCbCr color space if input is RGB
    if size(im, 3) == 3
        im = 255 .* rgb2ycbcr(im ./ 255);
    end
    painted_im = im;
    
    % Run iterations
    for iter=1:max_iter
        
        % Perform gradient update
        for c=1:size(im, 3)
            dI = mask .* reshape(foe_energy_grad_x(painted_im(:,:,c), basis, W, a), [size(im, 1) size(im, 2)]);
            painted_im(:,:,c) = painted_im(:,:,c) - eta * dI;
        end
        
        % Compute energy of likelihood (only for masked area)
        if ~rem(iter, 10)
            E = foe_energy(painted_im, basis, W, a, size(painted_im));
            disp(['Iteration ' num2str(iter) ': energy is ' num2str(E)]);
                
            % Show intermediate result
            if size(im, 3) == 3
                tmp1 = uint8(round(255 .* ycbcr2rgb(im ./ 255)));
                tmp2 = uint8(round(255 .* ycbcr2rgb(painted_im ./ 255)));
            else
                tmp1 = uint8(round(im));
                tmp2 = uint8(round(painted_im));
            end
            subplot(1, 2, 1); imshow(tmp1); colormap(gray); title('Noisy image');
            subplot(1, 2, 2); imshow(tmp2); colormap(gray); title(['Inpainted image (iteration ' num2str(iter) ')']);
            drawnow
        end
        
        % Use last 250 iterations to clean up small artefacts
        if iter > max_iter - 250
            eta = 250;
        end
    end 
        
    % Convert back to RGB if necessary
    if size(painted_im, 3) == 3
        painted_im = 255 .* ycbcr2rgb(painted_im ./ 255);
    end 
    painted_im = uint8(round(painted_im));
    