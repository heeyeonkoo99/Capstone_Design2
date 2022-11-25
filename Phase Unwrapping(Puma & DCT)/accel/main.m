%   ================================================================
%   Copyright 2016, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: Example code
%   ================================================================

%close all; clc;
load('testimages.mat') % load test phase image
X = testimages{1};

levels = 2; % number of decomposition levels (both horizontally and vertically).
            % Set to zero to turn acceleration off.
m = 256;    % maximum value (0 corresponds to -pi, m to +pi)
K = 1;  % dilation operator size for higher wavelet levels applied on aliasing masks
KL = 0; % (optional parameter) number of wavelet levels without applied dilation

tic;
Y = accel_unwrapping(X, 'puma', levels, m, 1, K, KL);
time = toc;

fprintf(['Total elapsed time: ' num2str(time) ' s\n\n']);

figure(11), imagesc(X), colormap(gray(256)), set(gca, 'Position', [0 0 1 1]), axis off;  % wrapped phase image
figure(12), imagesc(Y), colormap(gray(256)), set(gca, 'Position', [0 0 1 1]), axis off;  % unwrapped phase image
%figure(13), imagesc(Y-X), colormap(gray(256)), set(gca, 'Position', [0 0 1 1]), axis off;  % wrap count image