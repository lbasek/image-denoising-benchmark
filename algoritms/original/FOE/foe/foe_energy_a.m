function E = foe_energy_a(x, im, basis, W)
%FOE_ENERGY_A Compute value of FoE energy function for a specific a
%
%   E = foe_energy_a(x, im, W)
%
% Computes the enegery value of the Field of Experts model defined by 
% parameters W and a at point x. The energy is returned in E.
%
% This function is only used to check the gradient FOE_ENERGY_GRAD_A.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Compute energy
    a = x;
    E = foe_energy(im, basis, W, a);