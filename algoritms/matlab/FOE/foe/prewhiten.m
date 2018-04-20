function [X, W] = prewhiten(X)
%PREWHITEN Performs prewhitening of a dataset X
%
%   [X, W] = prewhiten(X)
%
% Performs prewhitening of the dataset X. Prewhitening concentrates the main
% variance in the data in a relatively small number of dimensions, and 
% removes all first-order structure from the data. In other words, after
% the prewhitening, the covariance matrix of the data is the identity
% matrix. The function returns the applied linear mapping in W.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Compute and apply the ZCA mapping
    X = X - repmat(mean(X, 1), [size(X, 1) 1]);
    W = inv(sqrtm(cov(X)));
    X = X * W;    
    