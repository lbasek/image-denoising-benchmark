function E = foe_energy(x, basis, W, a, size_im)
%FOE_ENERGY Compute value of FoE energy function at point x
%
%   E = foe_energy(x, basis, W, a, size_im)
%
% Computes the enegery value of the Field of Experts model defined by 
% parameters W and a at point x. The energy is returned in E.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Initialize some variables
    E = 0;
    W = basis' * W;
    patch_size = sqrt(size(W, 1));
    if any(size(x) == 1)
        im = reshape(x, size_im);
    else
        im = x;
    end

    % Loop over all cliques to sum energy
    for i=1:size(W, 2)
        for c=1:size(im, 3)
            tmp = conv2(im(:,:,c), reshape(W(end:-1:1,i), [patch_size patch_size]), 'valid');    
            E = E + a(i) * sum(log(1 + .5 * tmp(:) .^ 2));
        end
    end
