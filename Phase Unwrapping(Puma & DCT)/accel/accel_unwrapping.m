%   ================================================================
%   Copyright 2016, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: entry point for the unwrapping accelerator applied on multiple algorithms
%   ================================================================

function Y = accel_unwrapping(X, algo, lev, m, constn, K, KL)
% INPUTS:
    % 'X' is the wrapped phase map to be unwrapped
    % 'lev' is the number of (2D) decompositions levels
    % 'm' is the maximum value of 'X' (0 corresponds to -pi, m to +pi)
% Optional constants:
    % 'constn' is a factor to modify the threshold detecting aliasing applied on the highpass channel. (default: 1)
    % 'K': size of dilation operator. (default: 0)
    % 'KL': from what level the dilation must be applied onwards (k=0 at kl first levels) (default: 0)
    
% OUTPUT:
    % Returns the unwrapped map in 'Y'.
    addpath('sourcecode');
    if ~exist('constn','var');    constn = 1;     end;
    if ~exist('K','var');         K = 0;          end;
    if ~exist('KL','var');        KL = 0;         end;

    % select algorithm
    switch algo
        case 'f2dpu'
            unwrapper = @accel_unwrapping_fast2d;
        case 'puma'
            unwrapper = @accel_unwrapping_puma;
        otherwise
            error(['unknown algorithm identifier "' algo '"'])
    end
    
    Y = unwrapper(X, lev, m, constn, K, KL);  

end

