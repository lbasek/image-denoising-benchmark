function dE = foe_energy_grad_w(x, im, basis, a)
%FOE_ENERGY_GRAD_W Computes gradient of FoE energy function at point x
%
%   dE = foe_energy_grad_w(x, im, basis, a)
%
% Computes the energy gradient of the Field of Experts model defined by 
% parameters W and a at point x. The gradient is returned in dE.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Initialize some variables
    W = reshape(x, [numel(x) / numel(a) numel(a)]);
    patch_size = ceil(sqrt(size(W, 1)));
    if size(im, 1) ~= size(im, 2)
        im = reshape(im, [sqrt(numel(im)) sqrt(numel(im))]);
    end
    dE = zeros(size(W));
    
    % Loop over all cliques to sum energy gradient
    for y=1:size(im, 1) - patch_size + 1
        for x=1:size(im, 2) - patch_size + 1
            X = im(y:y + patch_size - 1, x:x + patch_size - 1);
            X = basis * X(:);
            WX = X' * W;
            dE = dE - X * (WX ./ (1 + .5 * WX .^ 2));
        end
    end
    dE = bsxfun(@times, dE, a');
    dE = -dE(1:end);
    
%     % Loop over all cliques using convolution
%     dE2 = zeros(size(W));
%     W = basis' * W;
%     for i=1:size(W, 2)
%         tmp = conv2(im, reshape(W(end:-1:1,i), [patch_size patch_size]), 'same');
%         WX = tmp ./ (1 + .5 * tmp .^ 2);
%         for y=1:size(im, 1) - patch_size + 1
%             for x=1:size(im, 2) - patch_size + 1
%                 X = im(y:y + patch_size - 1, x:x + patch_size - 1);
%                 X = basis * X(:);
%                 dE2(:,i) = dE2(:,i) - X(:) * WX(y, x);
%             end
%         end
%     end
%     dE2 = bsxfun(@times, dE2, a');
%     dE2 = dE2(1:end);    
%     sum(sum(abs(dE - dE2)))
    