%   ================================================================
%   Copyright 2015, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: Calculates the coefficient marker pyramid. This will guide the
%       unwrapping algorithm by denoting what pixels have to be unwrapped at what level.
%   ================================================================

function P = aliasing_collections(M, lev, k, kl)
% Converts a binary mask MHW coefficient plane M to a ternary pyramid A with 'lev' decomposition levels:
    % 0: already unwrapped (at a higher level)
    % 1: to be unwrapped at the present level
    % 2: still aliased in this plane, to be unwrapped at a lower level

% Optional dilation operators are provided to significantly reduce the chance of unwrapping defects at higher levels.
% k: size of dilation operator, kl: from what level the dilation must be applied onwards (k=0 at kl first levels)
    
    if nargin < 4
        kl=0;
        if nargin < 3
            k=0;
        end
    end

    A = single(M); P = cell(2*lev,1);
    P{1} = dstretch( dilateit( A(end/2+1:end, :), k*(kl==0) ));
    P{2} = recombineit( A(1:end/2, end/2+1:end)' , P{1}, kl==0);
    
    for l = 2:lev
        P{2*l-1} = recombineit( A(end/2^l+1:end/2^(l-1), 1:end/2^(l-1)), P{2*l-2}', l>kl )';
        P{2*l} = recombineit( A(1:end/2^l, end/2^l+1:end/2^(l-1))' , P{2*l-1}, l>kl );
    end
    
    P{2*lev+1} = single(squash(P{2*lev}')')+1;
    
    for j = 1:lev
        P{2*j-1} = addones(P{2*j-1});
        P{2*j} = addones(P{2*j}')';
    end
    
    function Y = recombineit(A,B,m)
        B = squash(B>0);
        Y = max( dstretch(dilateit(A,m*k))' | dilateit(B,m*k), 2*B);
    end % max(M(floor/2), 2*A(i-1))
    
    function Y = squash(X)
        Y = X(1:2:end,:) | X(2:2:end,:); 
    end

    function Y = dstretch(X)
        Y = imresize( X, [2*size(X,1) size(X,2)], 'nearest');
    end

    function X = addones(X)        
        X = max(X, dstretch(squash(X)));
    end

    function Y = dilateit(X,k)
        if k<1
            Y=X;
        else
            Y = imdilate( X, strel('disk', k));
        end
    end
end