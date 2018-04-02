% FDENOISENEURAL Denoise a black and white image corrupted by AWG noise.
%   denoisedIm = fdenoiseNeural(noisyIm, sigma, model)
%   Given a noisy image, returns a denoised version of that image.
%   The noise is assumed additive, white and Gaussian, with known and 
%   uniform variance.
% 
%   Inputs
%   ------
%   noisyIm: an image corrupted by AWG noise
%   sigma: the standard deviation of the noise
%   model: a struct containing:
%     * the sliding window stride of the denoising 
%       process (a smaller stride will usually provide better results).
%     * the width of the Gaussian window weighting the outputs of the MLP.
%     Can be left empty (model = {}).
%     The default parameter are: 
%       model.weightsSig = 2; % window width
%       model.step = 3; % stride
%   The pixels of the clean image are assumed to be approximately in 
%   the range 0..255.
%
%   Outputs
%   -------
%   denoisedIm: the estimate of the clean image.
%
%   Example
%   -------
%     im_noisy = im_clean + 25*randn(size(im_clean));
%     im_denoised = fdenoiseNeural(im_noisy, 25, {});
%     psnr_noisy = getPSNR(im_noisy, im_clean, 255);
%     psnr_denoised = getPSNR(im_denoised, im_clean, 255);
%
%   Author: Harold Christopher Burger
%   Date:   March 19, 2012.

function denoisedIm = fdenoiseNeural(noisyIm, sigma, model)

  if isempty(model)
    model = {};
    % width of the Gaussian window
    model.weightsSig = 2;
    % sliding window stride
    model.step = 3;
  end
  

  % load the weights
  load('weights_cvpr.mat');


  patchSz = sqrt(size(w{1}, 2)-1);
  patchSzOut = sqrt(size(w{length(w)},1));

  p_diff = (patchSz - patchSzOut)/2;
  % check if input is larger than output. In that case, extend the image
  sz = size(noisyIm);
  if (p_diff>0)
    noisyIm = [fliplr(noisyIm(:,(1:p_diff)+1)) noisyIm fliplr(noisyIm(:, sz(2)-p_diff:sz(2)-1))];  
    noisyIm = [flipud(noisyIm((1:p_diff)+1,:)); noisyIm; flipud(noisyIm((sz(1)-p_diff:sz(1)-1), :))];  
  end


  pixel_weights = zeros(patchSzOut);
  mid = ceil(patchSzOut/2);
  sig = floor(patchSzOut/2)/model.weightsSig;
  for i=1:patchSzOut
    for j=1:patchSzOut
      d = sqrt((i-mid)^2 + (j-mid)^2);    
      pixel_weights(i,j) = exp((-d^2)/(2*(sig^2))) / (sig*sqrt(2*pi));
    end
  end
  pixel_weights = pixel_weights/max(pixel_weights(:));


  noisyIm = ((noisyIm/255)-0.5)/0.2;


  p_out = image2cols(noisyIm, patchSz, model.step);
  p_final = zeros(patchSzOut^2, size(p_out,2));
  done = false;
  idx = 1;
  chunkSize = 10000;
  while ~done
    % do this in chunks to avoid memory problems
    idx_end = min(idx+chunkSize,size(p_out,2));
    part = p_out(:, idx:idx_end); 

    % forward through the different layers
    for i=1:length(w)
      part = [part; ones(1, size(part, 2))];
      if (i<length(w))
        part = tanh(w{i}*part);
      else
        p_final(:, idx:idx_end) = w{i}*part;
      end
    end
    % done?
    idx = idx + chunkSize;
    if (idx>size(p_out,2))
      done = true;
    end
  end
  clear p_out;

  % use pixel weights
  patches_w = repmat(pixel_weights(:), [1 size(p_final, 2)]);
  p_final = p_final.*patches_w;


  denoisedIm = columns2im(p_final, sz, model.step);
  wIm = columns2im(patches_w, sz, model.step);

  denoisedIm = denoisedIm./wIm;
	

  denoisedIm = ((denoisedIm*0.2)+0.5)*255;

  clear w; 
  clear patches_w;
  clear wIm;

return


