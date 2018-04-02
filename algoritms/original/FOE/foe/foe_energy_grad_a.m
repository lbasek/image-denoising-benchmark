function dE = foe_energy_grad_a(x, im, basis, W)
%FOE_ENERGY_GRAD_W Computes gradient of FoE energy function at point x
%
%   dE = foe_energy_grad_w(x, im, W)
%
% Computes the energy gradient of the Field of Experts model defined by 
% parameters W and a at point x. The gradient is returned in dE.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Initialize some variables
    a = x;
    W = basis' * W;
    patch_size = sqrt(size(W, 1));
    if size(im, 1) ~= size(im, 2)
        im = reshape(im, [sqrt(numel(im)) sqrt(numel(im))]);
    end
    dE = zeros(size(a));
    
    % Loop over all cliques using convolution
    for i=1:size(W, 2)
        WX = conv2(im, reshape(W(end:-1:1, i), [patch_size patch_size]), 'valid');
        dE(i) = sum(log(1 + .5 * WX(:) .^ 2));
    end