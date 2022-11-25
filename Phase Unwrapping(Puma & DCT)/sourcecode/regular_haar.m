%   ================================================================
%   Copyright 2015, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: Applies the Haar wavelet transform (either forward or inverse) on an image with 'lev' levels,
%   ================================================================

function X = regular_haar(X,lev)

    if lev < 0
        for l = -lev:-1:1
            f = 2^(l-1);
            X(1:size(X,1)/f,1:size(X,2)/f) = transformstep_b(X(1:size(X,1)/f,1:size(X,2)/f));
        end
    else
        for l = 1:lev
            f = 2^(l-1);
            X(1:size(X,1)/f,1:size(X,2)/f) = transformstep(X(1:size(X,1)/f,1:size(X,2)/f));
        end
    end

    function X = transformstep(X)
        A = X(1:2:end-1,:);
        B = X(2:2:end,:);
        
        B = B - A;
        A = A + .5*B;
        
        X = [A;B];
    end

    function X = transformstep_b(X)
        A = X(1:end/2,:);
        B = X(end/2+1:end,:);
        
        A = A - .5*B;
        B = B + A;
        
        X(1:2:end-1,:) = A;
        X(2:2:end,:) = B;
    end   

end

