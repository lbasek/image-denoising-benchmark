function dE = foe_energy_grad_x(x, basis, W, a, size_im)
%FOE_ENERGY_GRAD_x Computes gradient of FoE energy function at point x
%
%   dE = foe_energy_grad_x(x, basis, W, a, size_im)
%
% Computes the energy gradient of the Field of Experts model defined by 
% parameters W and a at point x. The gradient is returned in dE.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Initialize some variables
    W = basis' * W;
    patch_size = sqrt(size(W, 1));
    if any(size(x) == 1)
        im = reshape(x, size_im);
    else
        im = x;
    end
    dE = zeros(size(im));

    % Loop over all cliques using convolution
    pad_size = floor(patch_size / 2);
    WX = zeros(size(im));
    invW = W(end:-1:1,:);
    for i=1:size(W, 2)
        tmp = conv2(im, reshape(invW(:,i), [patch_size patch_size]), 'valid');
        WX(pad_size+1:end-pad_size, pad_size+1:end-pad_size) = tmp;
        dE = dE - conv2(a(i) * (WX ./ (1 + .5 * WX .^ 2)), ...
                               reshape(W(:,i), [patch_size patch_size]), 'same');
    end
    dE = -dE(1:end); 
    