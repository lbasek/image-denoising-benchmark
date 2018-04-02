function [W, a, train_err] = train_foe(images, basis, no_experts, a)
%TRAIN_FOE Trains a Field of Experts model on a collection of images
%
%   [W, a, train_err] = train_foe(images, basis, no_experts)
%   [W, a, train_err] = train_foe(images, basis, W, a)
%
% Trains a Field of Experts model on a set of (grayscale) images. The
% potential functions of the MRF are given by the energy function of a
% product of no_experts Student-t distributions (with parameters W and a).
% The potential functions are defined over a cliques that are image patches
% of patch_size x patch_size pixels.
%
%
% (C) Laurens van der Maaten, 2009
% Delft University of Technology


    % Initialize parameters
    eta_W = .01;
    eta_a = .1;
    max_iter = 1000;
    no_images = size(images, 1);
    size_im = sqrt(size(images, 2));
    batch_size = min(200, no_images);
    momentum = .9;
    train_err = zeros(max_iter, 1);
    addpath(genpath('netlab'));

    % Initialize model
    if exist('a', 'var')
        W = no_experts;
    else
        W = randn(size(basis, 1), no_experts);
        a = repmat(0.01, [no_experts 1]);
    end
    prev_dW = zeros(size(W));
    prev_da = zeros(size(a));
    
    % Perform training of the model
    for iter=1:max_iter
        
        % Create batches
        tic
        ind = randperm(no_images);
        disp(['Iteration ' num2str(iter) '...']);
        
        % Loop over batches
        for b=1:batch_size:no_images
            
            % Get batch and initialize positive and negative data
            batch = images(ind(b:b + batch_size - 1),:); 
            pos_W = zeros(size(W)); pos_a = zeros(size(a));
            neg_W = zeros(size(W)); neg_a = zeros(size(a));
        
            % Loop over all training images to compute gradient terms
            for i=1:batch_size

                % Get image
                im = reshape(batch(i,:), [size_im size_im]);
                
%                 % Check gradients
%                 options = zeros(18, 1);
%                 options(9) = 1;
%                 hmc('foe_energy_w', W(1:end), options, 'foe_energy_grad_w', im, basis, a);
%                 hmc('foe_energy_a', a, options, 'foe_energy_grad_a', im, basis, W);
%                 hmc('foe_energy', im(1:end), options, 'foe_energy_grad_x', basis, W, a, [size_im size_im 1]);

                % Compute positive part of gradient
                pos_W = pos_W + reshape(foe_energy_grad_w(W(1:end), im, basis, a), size(W));
                pos_a = pos_a + foe_energy_grad_a(a, im, basis, W);

                % Draw samples from model using hybrid Monte Carlo
                options = zeros(18, 1);
                options(1)  = 0;                    % do not print diagnostics
                options(5)  = 0;                    % do not use momentum persistence
                options(7)  = 30;                   % number of leaps (= steps in leap-frog)
                options(9)  = 0;                    % do not check gradient
                options(14) = 1;                    % number of samples to return
                options(15) = 0;                    % number of samples to omit from start
                sample = hmc('foe_energy', batch(i,:), options, 'foe_energy_grad_x', basis, W, a, [size_im size_im 1]);
                
                % Compute negative CD part
                neg_W = neg_W + reshape(foe_energy_grad_w(W(1:end), sample, basis, a), size(W));
                neg_a = neg_a + foe_energy_grad_a(a, sample, basis, W);
            end

            % Perform the gradient updates
            prev_dW = eta_W * (momentum * prev_dW + (1 - momentum) * (1 / batch_size) * (pos_W - neg_W));
            prev_da = eta_a * (momentum * prev_da + (1 - momentum) * (1 / batch_size) * (pos_a - neg_a));
            W = W + prev_dW;
            a = exp(log(a) + a .* prev_da);
        end
        
        % Evaluate sum of energies of training data
        sum_E = 0;
        for i=1:no_images
            im = reshape(images(i,:), [size_im size_im]);
            sum_E = sum_E + foe_energy(im, basis, W, a);
        end
        disp(['     mean energy of training data is ' num2str(sum_E ./ no_images)]);
        train_err(iter) = sum_E ./ no_images;
        toc
    end
    