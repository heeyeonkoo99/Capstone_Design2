%   ================================================================
%   Copyright 2015, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: the unwrapping accelerator applied on the algorithm used in:
%       M. A. Herraez, D. R. Burton, M. J. Lalor, and M. A. Gdeisat, "Fast two-dimensional phase-unwrapping algorithm
%       based on sorting by reliability following a noncontinuous path," Appl. Opt. 41, 7437–7444 (2002).
%   ================================================================

function L = accel_unwrapping_fast2d(X, lev, m, constn, K, KL)
% This file accelerates the "Fast two-dimensional phase-unwrapping" algorithm with modulo wavelets.

    % apply standard algorithm
    if lev <= 0
        
        [XE, YE] = splitedges(reliability_calc_full(X,m));
        L = fast2d_unwrap(X, ones(size(X)), XE, YE, m)*m + X;
        
    % apply accelerated algorithm
    else
        
        % calculate aliasing 
        [W,PYR] = modulo_haar_pyr(X,lev,m);
        M = (abs(W) >= constn*m/4);
       
        L = W;
        M = aliasing_collections(M,lev,K,KL);
            
        cnt = length(PYR); % decrementing cell counter for pyramid  
            
        % calculate reliability maps (specific to this unwrapping algorithm)
        RP = get_reliability_pyramid(lev);
        [XE, YE] = splitedges(RP{cnt});
        
        % unwrap pixels at highest level
        [L(1:end/2^lev,1:end/2^lev), G, GL] = fast2d_unwrap(W(1:end/2^lev,1:end/2^lev), M{cnt}, XE, YE, m);
        
        L(1:end/2^lev,1:end/2^lev) = W(1:end/2^lev,1:end/2^lev) + m*L(1:end/2^lev,1:end/2^lev); 
        cnt = cnt-1;

        % unwrap specific coefficients at every subsequent wavelet level
        for l = lev:-1:1
           L(1:end/2^l,1:end/2^(l-1)) = ...
               rev_wav_unwrap(L(1:end/2^l,1:end/2^(l-1))', PYR{cnt}', M{cnt}', RP{cnt}')';

           cnt = cnt-1;

           L(1:end/2^(l-1),1:end/2^(l-1)) = ...
               rev_wav_unwrap(L(1:end/2^(l-1),1:end/2^(l-1)), PYR{cnt},  M{cnt}, RP{cnt});

           cnt = cnt-1;
        end
    
    end
    
    % conditional reverse modulo wavelet transform
    function R = rev_wav_unwrap(A, P, mask, REL)
        R = regular_haar(A,-1).*(~mask) + P.*(mask>0);
        
        GL = grouptranspose(GL, size(G));
        G = imresize( G', [2*size(G,2) size(G,1)], 'nearest');
        
        [XE, YE] = splitedges(REL);
        [R, G, GL] = fast2d_unwrap(R, mask, XE, YE, m, G, GL);
        R = P + m*R;
    end

    % calculates reliability map for every wavelet level
    function RP = get_reliability_pyramid(lev)
        s = 2*lev+1;
        RP = cell(s,1);
        RP{1} = reliability_calc_full(X,m);
        
        for i = 2:2:s
             RP{i} = RP{i-1}(1:2:end,:) + RP{i-1}(2:2:end,:);
             RP{i+1} = RP{i}(:,1:2:end) + RP{i}(:,2:2:end);
        end
    end

    % (subroutines for unwrapper)
    function [XE, YE] = splitedges(R)        
        XE = R(1:end-1,:) + R(2:end,:);
        YE = R(:,1:end-1) + R(:,2:end);        
    end
end