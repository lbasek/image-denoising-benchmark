function E = foe_energy_w(x, im, basis, a)
%ENERGY Compute value of FoE energy function at point x
%
%   E = foe_energy(x, W, a)
%
% Computes the enegery value of the Field of Experts model defined by 
% parameters W and a at point x. The energy is returned in E.
%
% This function is only used to check the gradient FOE_ENERGY_GRAD_W.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Compute energy
    W = reshape(x, [numel(x) / numel(a) numel(a)]);
    E = foe_energy(im, basis, W, a);