%   ================================================================
%   Copyright 2016, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: the unwrapping accelerator applied on the algorithm used in:
%       Bioucas-Dias, J.M.; Valadao, G., "Phase Unwrapping via Graph Cuts," in Image Processing,
%       IEEE Transactions on, vol.16, no.3, pp.698-709, March 2007
%   ================================================================

function [L, times] = accel_unwrapping_puma(X, lev, m, constn, K, KL)
% This file accelerates the "PUMA" algorithm with modulo wavelets.

    G = uint32(zeros(size(X)/2^lev)); % Group index matrix
    GC = uint32(0);                   % Group count matrix (with dummy element)
    times = [0;0];                    % computation times
    
    % apply standard algorithm
    if lev <= 0
        
        M = uint8(ones(size(X)));
        L = puma_unwrap(X, M);
        
    % apply accelerated algorithm
    else
            
        % calculate aliasing 
        [L,PYR] = modulo_haar_pyr(X,lev,m);
        L = single(L);
        M = (abs(L) >= constn*m/4);
        M = aliasing_collections(M,lev,K,KL);
        
        cnt = length(PYR); % decrementing cell counter for pyramid  
        
        % unwrap pixels at highest level
        L(1:end/2^lev,1:end/2^lev) = puma_unwrap(L(1:end/2^lev,1:end/2^lev), uint8(M{cnt}));
        cnt = cnt-1;
        
        % unwrap specific coefficients at every subsequent wavelet level
        for l = lev:-1:1
           L(1:end/2^l,1:end/2^(l-1)) = ...
               rev_wav_unwrap(L(1:end/2^l,1:end/2^(l-1))', PYR{cnt}', M{cnt}')';
           cnt = cnt-1;

           L(1:end/2^(l-1),1:end/2^(l-1)) = ...
               rev_wav_unwrap(L(1:end/2^(l-1),1:end/2^(l-1)), PYR{cnt},  M{cnt});
       
           cnt = cnt-1;
        end
    
    end
    
    % Timing
    global graphconstruct_duration;
    graphconstruct_duration = graphconstruct_duration + times(1);
    
    global algo_duration;
    algo_duration = algo_duration + times(2);
    
        disp(['overhead: ' num2str(times(1))]);
        disp(['PUMA: ' num2str(times(2))]);
    
    % conditional reverse modulo wavelet transform
    function R = rev_wav_unwrap(A, P, mask)
        R = regular_haar(A,-1).*(~mask) + P.*(mask>0);

        GC = 2*GC;
        G = imresize( G', [2*size(G,2) size(G,1)], 'nearest');
        
        R = puma_unwrap(R, uint8(mask));
    end

    % call exteral C++ code for PUMA unwrapping
    % Note: This implementation uses a specific version of PUMA where the clique factor exponent p=2 and no quality map is used.
    function R = puma_unwrap(X, M)
        PGI = packGI(G,single(X));
        CC = bwconncomp(M==1,4);
        CC = cellfun(@(x) uint32(x-1), CC.PixelIdxList, 'UniformOutput', 0);
        
        [PGI, GC, tt] = mf4(PGI, M, GC, CC, single(m));
        times = times + tt;
        
        [G,R] = unpackGI(PGI);
    end
end